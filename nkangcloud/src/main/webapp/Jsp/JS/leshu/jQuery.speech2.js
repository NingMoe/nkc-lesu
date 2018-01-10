/*
Create By AZ
Date: 2016-01-11 
blog: http://www.tuterm.com
可以任意使用，保留作者信息以溯源
*/
;
(function($) {
	$.fn.speech = function(options) {
		var defaults = {
			"speech": true, //通过点击链接播报，还是直接播报
			"lang": "zh", //语言			
			"speed": speed, //语速			
			"sWidth": 16, //链接按钮的宽度			
			"sHeight": 13, //链接按钮的高度		
			"https": true, //启用https	
			"bg": "./image/speech.png", //链接按钮的背景图片			
			"content": "这是一段测试内容" //直接播报内容
		};
		var options = $.extend(defaults, options);
		return this.each(function() {
			var _this = $(this),
				_iframe = _this.find(".speech_iframe"),
				http = options.https ? "http" : "http",
				content = _this.text();
			content = (!content || content === undefined || content === null) ? options.content : content;


			if (options.speech) {
				//点击链接播报
				var _speech = $(".start");
				_speech.on('click', function() { //捕获点击事件	
					var tempTime=minute*60+ (millisecond / 1000) + second;
					if(qt=="minute"&&minute>=5&&second>=0){
						$("#next").val("查看战绩");
					}
					if($("#next").val()!="查看战绩"){
					$("#startPanel").hide();
					$("#answerPanel").hide();
					$("#fakePanel").show();
					}
					if(qt=="minute"&&second>300){
						$("#next").val("下一题");
					}
					if($(this).val()=="查看战绩"){

						if(isExternal=="yes"){
							swal({  
						        title:"长按下图关注乐数享更多定制化一对一培训~",  
						        text:"<img src='http://leshucq.bj.bcebos.com/standard/QRCode.jpg' alt='' />",
						        html:"true",
						        showConfirmButton:false, 
								showCancelButton: true,   
								closeOnConfirm: false,   
						        cancelButtonText:"我知道了",
						        animation:"slide-from-top"  
						      }, 
								function(inputValue){
									if (inputValue === false){
										return false;
									}
						      });
						
							$("#endPanel").hide();
							$("#timestext").hide();
							$("#timetext").hide();
							$("#answerPanel").hide();
							return;
						}
						else if(!IsRegistered){
							swal({  
							title:"注册乐数享更多定制化一对一珠心算在线培训~",  
					        text:"<img src='http://leshucq.bj.bcebos.com/standard/leshuLogo2.jpg' width='50%' alt='' />",
					        html:"true",
					        showConfirmButton:true, 
							showCancelButton: false,   
							closeOnConfirm: false,   
					        confirmButtonText:"我要注册", 
					        animation:"slide-from-top"  
					      }, 
							function(inputValue){
								if (inputValue === false){
									return false;
								}
								else{
									window.location.href="http://leshucq.bceapp.com/mdm/profile.jsp?UID="+uid;
								}
					      });
					
						$("#endPanel").hide();
						$("#timestext").hide();
						$("#timetext").hide();
						$("#answerPanel").hide();
						return;
						}
						else{
						FusionCharts.ready(function() {
							var cSatScoreChart = new FusionCharts({
								type : 'angulargauge',
								renderAt : 'chart-container',
								width : '400',
								height : '250',
								dataFormat : 'json',
								dataSource : {
									"chart" : {
										"caption" : "计时统计",
										"subcaption" : "计算时间(秒)",
										"lowerLimit" : "0",
										"upperLimit" : "60",
										"lowerLimitDisplay" : "真棒",
										"upperLimitDisplay" : "加油",
										"showValue" : "1",
										"valueBelowPivot" : "1",
										"theme" : "fint"
									},
									"colorRange" : {
										"color" : [ {
											"minValue" : "0",
											"maxValue" : "24",
											"code" : "#6baa01"
										}, {
											"minValue" : "24",
											"maxValue" : "48",
											"code" : "#f8bd19"
										}, {
											"minValue" : "48",
											"maxValue" : "60",
											"code" : "#e44a00"
										} ]
									},
									"dials" : {
										"dial" : [ {
											"value" : tempTime
										} ]
									}
								}
							}).render();
							var revenueChart = new FusionCharts({
						        type: 'msbar2d',
						        renderAt: 'chart-container2',
						        width: '400',
						        height: '250',
						        dataFormat: 'json',
						        dataSource: {
						            "chart": {
						                "caption": "听算正误统计",
						                "yAxisname": "",
						                "numberPrefix": "",
						                "paletteColors": "#1aaf5d,#FF0005",
						                "bgColor": "#ffffff",
						                "showBorder": "0",
						                "showHoverEffect":"1",
						                "showCanvasBorder": "0",
						                "usePlotGradientColor": "0",
						                "plotBorderAlpha": "10",
						                "legendBorderAlpha": "0",
						                "legendShadow": "0",
						                "placevaluesInside": "1",
						                "valueFontColor": "#ffffff",
						                "showXAxisLine": "1",
						                "xAxisLineColor": "#999999",
						                "divlineColor": "#999999",               
						                "divLineIsDashed": "1",
						                "showAlternateVGridColor": "0",
						                "subcaptionFontBold": "0",
						                "subcaptionFontSize": "14"
						            },            
						            "categories": [
						                {
						                    "category": [
						                        {
						                            "label": "听算"
						                        }
						                    ]
						                }
						            ],            
						            "dataset": [
						                {
						                    "seriesname": "正确",
						                    "data": [
						                        {
						                            "value": rightQ
						                        }
						                    ]
						                }, 
						                {
						                    "seriesname": "错误",
						                    "data": [
						                        {
						                            "value": wrongQ
						                        }
						                    ]
						                }
						            ],
						            "trendlines": [
						                {
						                    "line": [
						                        {
						                            "startvalue": "2",
						                            "color": "#0075c2",
						                            "valueOnRight": "1",
						                            "displayvalue": " "
						                        },
						                        {
						                            "startvalue": "8",
						                            "color": "#1aaf5d",
						                            "valueOnRight": "1",
						                            "displayvalue": " "
						                        }
						                    ]
						                }
						            ]
						        }
						    }).render();    
						});

						$("#chart-container2").show();
						$("#chart-container").show();
						$("#startPanel").show();
						$("#answerPanel").hide();
						$("#fakePanel").hide();
						$(this).val("下一题");
						return;
					}
					}
					$("#answer").val("");
					if(qt=="question"){
					if(totalTime==10){
						reset();
						totalTime=0;
						 $("#chart-container").hide();
						 $("#chart-container2").hide();
						 wrongQ=0;
						 rightQ=0;
					}
					if(totalTime==0){
						timeStart();
					}
					
					}
					else if(qt=="minute"){
						if(millisecond==0&&second==0&&minute==0){
						$("#chart-container").hide();
						$("#chart-container2").hide();				 
						wrongQ=0;
						 rightQ=0;
						timeStart();}
						if(minute>=5&&second>=0){
							swal("答题结束", "五分钟到了噢~！", "warning");
							timeStop();
							FusionCharts.ready(function() {
								var cSatScoreChart = new FusionCharts({
									type : 'angulargauge',
									renderAt : 'chart-container',
									width : '400',
									height : '250',
									dataFormat : 'json',
									dataSource : {
										"chart" : {
											"caption" : "计时统计",
											"subcaption" : "计算时间(秒)",
											"lowerLimit" : "0",
											"upperLimit" : "60",
											"lowerLimitDisplay" : "真棒",
											"upperLimitDisplay" : "加油",
											"showValue" : "1",
											"valueBelowPivot" : "1",
											"theme" : "fint"
										},
										"colorRange" : {
											"color" : [ {
												"minValue" : "0",
												"maxValue" : "24",
												"code" : "#6baa01"
											}, {
												"minValue" : "24",
												"maxValue" : "48",
												"code" : "#f8bd19"
											}, {
												"minValue" : "48",
												"maxValue" : "60",
												"code" : "#e44a00"
											} ]
										},
										"dials" : {
											"dial" : [ {
												"value" : tempTime
											} ]
										}
									}
								}).render();
								var revenueChart = new FusionCharts({
							        type: 'msbar2d',
							        renderAt: 'chart-container2',
							        width: '400',
							        height: '250',
							        dataFormat: 'json',
							        dataSource: {
							            "chart": {
							                "caption": "听算正误统计",
							                "yAxisname": "",
							                "numberPrefix": "",
							                "paletteColors": "#1aaf5d,#FF0005",
							                "bgColor": "#ffffff",
							                "showBorder": "0",
							                "showHoverEffect":"1",
							                "showCanvasBorder": "0",
							                "usePlotGradientColor": "0",
							                "plotBorderAlpha": "10",
							                "legendBorderAlpha": "0",
							                "legendShadow": "0",
							                "placevaluesInside": "1",
							                "valueFontColor": "#ffffff",
							                "showXAxisLine": "1",
							                "xAxisLineColor": "#999999",
							                "divlineColor": "#999999",               
							                "divLineIsDashed": "1",
							                "showAlternateVGridColor": "0",
							                "subcaptionFontBold": "0",
							                "subcaptionFontSize": "14"
							            },            
							            "categories": [
							                {
							                    "category": [
							                        {
							                            "label": "听算"
							                        }
							                    ]
							                }
							            ],            
							            "dataset": [
							                {
							                    "seriesname": "正确",
							                    "data": [
							                        {
							                            "value": rightQ
							                        }
							                    ]
							                }, 
							                {
							                    "seriesname": "错误",
							                    "data": [
							                        {
							                            "value": wrongQ
							                        }
							                    ]
							                }
							            ],
							            "trendlines": [
							                {
							                    "line": [
							                        {
							                            "startvalue": "2",
							                            "color": "#0075c2",
							                            "valueOnRight": "1",
							                            "displayvalue": " "
							                        },
							                        {
							                            "startvalue": "8",
							                            "color": "#1aaf5d",
							                            "valueOnRight": "1",
							                            "displayvalue": " "
							                        }
							                    ]
							                }
							            ]
							        }
							    }).render();    
							});
							$("#chart-container").show();
							$("#chart-container2").show();
							$("#answerPanel").hide();
							$("#startPanel").show();
							$("#fakePanel").hide();
							reset();
							totalTime=0;
						return;
						}
					}

					totalTime++;
					if(qt=="question"){
						$("#timestext").val(totalTime+"/10");
					}else if(qt=="minute"){
						$("#timestext").val("第"+totalTime+"题");
					}
				$("#answer").val("");
				var src = http + '://tts.baidu.com/text2audio?lan=' + options.lang + '&ie=UTF-8&text=' + getNum() + '&spd='+speed;				
					_iframe.length > 0 ? _iframe.attr("src", src) : (function() {
						var iframe = "<audio controls='' autoplay='' name='media' onended='endVoice()'><source id='voice' src='' type='audio/mp3'></audio>";
						_this.append(iframe);
						$("#voice").attr("src",src);
					})();
				});
			} else { //自动播报
				_iframe.length > 0 ? _iframe.attr("src", src) : (function() {
					var iframe = "<iframe height='0' width='0' class='speech_iframe' scrolling='no' frameborder='0' src='" + src + "' ></iframe>";
					_this.append(iframe);
				})();
			}
		});
	};
})(jQuery);