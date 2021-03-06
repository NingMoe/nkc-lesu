﻿(function($) {
    $.fn.jquizzy = function(settings) {
        var defaults = {
            questions: null,
            startImg: 'images/start.gif',
            endText: '已结束!',
            shortURL: null,
            sendResultsURL: "test",
            resultComments: {
                perfect: '你是爱因斯坦么?',
                excellent: '非常优秀!',
                good: '很好，发挥不错!',
                average: '一般般了。',
                bad: '太可怜了！',
                poor: '好可怕啊！',
                worst: '悲痛欲绝！'
            }
        };
        var config = $.extend(defaults, settings);
        if (config.questions === null) {
            $(this).html('<div class="intro-container slide-container"><h2 class="qTitle">Failed to parse questions.</h2></div>');
            return;
        }
        var superContainer = $(this),
        answers = [],scores=[],totalScore=0,
        exitFob = '<div class="results-container slide-container"><div class="question-number">' + config.endText + '</div><div class="result-keeper"></div></div><div class="notice">请选择一个选项！</div><div class="progress-keeper" ><div class="progress"></div></div>',
        contentFob = '',
        questionsIteratorIndex,
        caseStudy='',
        img='',
        answersIteratorIndex;
        superContainer.addClass('main-quiz-holder');
        for (questionsIteratorIndex = 0; questionsIteratorIndex < config.questions.length; questionsIteratorIndex++) {
        	if(config.questions[questionsIteratorIndex].caseStudy!="null"){
        		caseStudy='<div class="question">' + config.questions[questionsIteratorIndex].caseStudy + '</div>';
        	}
        	if(config.questions[questionsIteratorIndex].img!="null"){
        		img='<div style="width: 100%;"><img src="'+config.questions[questionsIteratorIndex].img+'" alt="" style="width: 100%;" /></div>';
        	}
            contentFob += '<div class="slide-container"><div class="question-number">' + (questionsIteratorIndex + 1) + '/' + config.questions.length + '</div>'+caseStudy+'<div class="question">' + config.questions[questionsIteratorIndex].question + '</div>'+img+'<ul class="answers">';
            for (answersIteratorIndex = 0; answersIteratorIndex < config.questions[questionsIteratorIndex].answers.length; answersIteratorIndex++) {
                contentFob += '<li><span class="type" style="display:none">'+config.questions[questionsIteratorIndex].type+'</span><span class="num">'+(answersIteratorIndex+1)+'</span><span class="content">' + config.questions[questionsIteratorIndex].answers[answersIteratorIndex] + '</span></li>';
            }
            contentFob += '</ul><div class="nav-container">';
            if (questionsIteratorIndex !== 0) {
                contentFob += '<span class="prev  i-btn i-next"><a class="nav-previous" href="#">上一题</a></span>';
            }
            if (questionsIteratorIndex < config.questions.length - 1) {
				
                contentFob += '<span class="next i-btn i-next"><a class="nav-next" href="#">下一题</a></span>';
            } else {
                contentFob += '<span class="next i-btn i-next final"><a class="nav-show-result" href="#">完成</a></span>';
            }
            contentFob += '</div></div>';
            answers.push(config.questions[questionsIteratorIndex].correctAnswer);
			scores.push(config.questions[questionsIteratorIndex].score);
			caseStudy="";
			img="";
        }
        superContainer.html(contentFob + exitFob);
        var progress = superContainer.find('.progress'),
        progressKeeper = superContainer.find('.progress-keeper'),
        notice = superContainer.find('.notice'),
        progressWidth = progressKeeper.width(),
        userAnswers = [],
        questionLength = config.questions.length,
        slidesList = superContainer.find('.slide-container');
        function checkAnswers() {
            var resultArr = [],
            flag = false;
            for (i = 0; i < answers.length; i++) {
                if (answers[i] == userAnswers[i]) {
                    flag = true;
					totalScore+=parseFloat(scores[i]);
                } else {
                    flag = false;
                }
                resultArr.push(flag);
            }
            return resultArr;
        }
        function roundReloaded(num, dec) {
            var result = Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
            return result;
        }
        function judgeSkills(score) {
            var returnString;
            if (score === 100) return config.resultComments.perfect;
            else if (score > 90) return config.resultComments.excellent;
            else if (score > 70) return config.resultComments.good;
            else if (score > 50) return config.resultComments.average;
            else if (score > 35) return config.resultComments.bad;
            else if (score > 20) return config.resultComments.poor;
            else return config.resultComments.worst;
        }
        progressKeeper.hide();
        notice.hide();
        slidesList.hide().first().fadeIn(500);
        superContainer.find('span.num').click(function() {
			var type=$(this).siblings(".type").text();
			var thisLi = $(this);
			if(type=='SingleChoice'||type=='TrueOrFalse'){
            if (thisLi.hasClass('selected')) {
                thisLi.removeClass('selected');
            } else {
                thisLi.parents('.answers').children('li').children('span').removeClass('selected');
                thisLi.addClass('selected');
            }
			}
			if(type=="MultipleChoice"){
				if (thisLi.hasClass('selected')) {
                thisLi.removeClass('selected');
            }
			else{
				thisLi.addClass('selected');
			}
			}
        });
        superContainer.find('.nav-start').click(function() {
            $(this).parents('.slide-container').fadeOut(500,
            function() {
                $(this).next().fadeIn(500);
                progressKeeper.fadeIn(500);
            });
            return false;
        });
        superContainer.find('.next').click(function() {
           /* if ($(this).parents('.slide-container').find('li span.selected').length === 0) {
                notice.fadeIn(300);
                return false;
            }*/
            notice.hide();
            $(this).parents('.slide-container').fadeOut(500,
            function() {
                $(this).next().fadeIn(500);
            });
            progress.animate({
                width: progress.width() + Math.round(progressWidth / questionLength)
            },
            500);
            return false;
        });
        superContainer.find('.prev').click(function() {
            notice.hide();
            $(this).parents('.slide-container').fadeOut(500,
            function() {
                $(this).prev().fadeIn(500);
            });
            progress.animate({
                width: progress.width() - Math.round(progressWidth / questionLength)
            },
            500);
            return false;
        });
		
		$('#submitInadvance').click(function() {
			totalScore=0;
            $('.final').click();
        });
		
        superContainer.find('.final').click(function() {
            /* if ($(this).parents('.slide-container').find('li span.selected').length === 0) {
                notice.fadeIn(300);
                return false;
            } */
			var answerIndex="";
			 
			 slidesList.each(function(index,domEle) {
				 $(domEle).css("display","none");
				 answerIndex="";
				 $(domEle).children(".answers").find("li span.selected").each(function(indexTemp,ss){
					 answerIndex+=$(ss).text()+"|";
				 });
				 
				answerIndex=answerIndex.substring(0,answerIndex.length-1);
                userAnswers.push(answerIndex+"");
				
				var obj=$(domEle).children(".answers").find("li span.selected");
				console.log(index+obj);
            });
            if (config.sendResultsURL !== null) {
                var collate = [];
				var userAns="";
                for (r = 0; r < config.questions.length; r++) {
                  collate.push('{"questionNumber":"' + r+1 + '", "userAnswer":"' + userAnswers[r] + '"}');		
				  }

				
                $.ajax({
                    type: 'POST',
                    url: config.sendResultsURL,
                    data: '{"answers": [' + collate.join(",") + ']}',
                    complete: function() {
                        console.log("OH HAI");
                    }
                });
            }
            progressKeeper.hide();
            var results = checkAnswers(),
            resultSet = '',
            trueCount = 0,
            shareButton = '',
            score,
            url;
            if (config.shortURL === null) {
                config.shortURL = window.location
            };
            for (var i = 0,
            toLoopTill = results.length; i < toLoopTill; i++) {
                if (results[i] === true) {
                    trueCount++;
                    isCorrect = true;
                }
                resultSet += '<div class="result-row">' + (results[i] === true ? "<div class='correct'>#"+(i + 1)+"<span></span></div>": "<div class='wrong'>#"+(i + 1)+"<span></span></div>");
                resultSet += '<div class="resultsview-qhover">' + config.questions[i].question;
                resultSet += "<ul>";
                for (answersIteratorIndex = 0; answersIteratorIndex < config.questions[i].answers.length; answersIteratorIndex++) {
                    var classestoAdd = '';
                    if (config.questions[i].correctAnswer == answersIteratorIndex + 1) {
                        classestoAdd += 'right';
                    }
                    if (userAnswers[i] == answersIteratorIndex + 1) {
                        classestoAdd += ' selected';
                    }
                    resultSet += '<li class="' + classestoAdd + '">' + config.questions[i].answers[answersIteratorIndex] + '</li>';
                }
                resultSet += '</ul></div></div>';
            }
            score = roundReloaded(trueCount / questionLength * 100, 2);
            
            resultSet = '<h2 class="qTitle">' + judgeSkills(score) + '<br/> 您的分数： ' + totalScore + '</h2>' + shareButton + '<div class="jquizzy-clear"></div>' + resultSet + '<div class="jquizzy-clear"></div>';
            superContainer.find('.result-keeper').html(resultSet).show(500);
            superContainer.find('.resultsview-qhover').hide();
            superContainer.find('.result-row').hover(function() {
                $(this).find('.resultsview-qhover').show();
            },
            function() {
                $(this).find('.resultsview-qhover').hide();
            });
            $(this).parents('.slide-container').fadeOut(500,
            function() {
                $(this).next().fadeIn(500);
            });
            return false;
        });
    };
})(jQuery);