<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%
int speed = Integer.parseInt(request.getParameter("speed"))+2;
String category = request.getParameter("category");
String wrongCollection = request.getParameter("wrongCollection");
String uid = request.getParameter("UID");
String level="";
if(uid!=null||uid!=""){
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
level=res.get("level");}
%>
<html>
<head>
<meta charset="utf-8" />
<title>乐数启蒙-听算练习</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script src="../Jsp/JS/fusioncharts/fusioncharts.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.widgets.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.theme.fint.js"></script>
<link rel="stylesheet" type="text/css"
	href="../Jsp/JS/leshu/bootstrap.min.css" />
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="http://www.jq22.com/jquery/jquery-ui-1.11.0.css">
<link rel="stylesheet"
	href="../Jsp/JS/speedTab/jquery-ui-slider-pips.min.css" />
<script src="../Jsp/JS/speedTab/jquery-plus-ui.min.js"></script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script src="../Jsp/JS/speedTab/jquery-ui-slider-pips.js"></script>
<script src="../Jsp/JS/speedTab/examples.js"></script>
<link rel="stylesheet" href="../Jsp/JS/speedTab/app.min.css" />
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css" />
<script src="../Jsp/JS/leshu/custom.js"></script>
<style type="text/css">
#endPanel,#right,#wrong,#chart-container,#chart-container2,#Result,#fakePanel {
	display: none;
}
.form_edit {    
width: 95%;
margin-left: 4%;
}
</style>
</head>
<body>

	<div id="data_model_div" style="height: 80px">
		<i class="icon"
			style="position: absolute; top: 20px; left: 20px; z-index: 100;">
			<img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;">
		</i> <img
			style="position: absolute; top: 8px; right: 20px; z-index: 100; height: 60px;"
			class="HpLogo"
			src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
<input type="text" id="timestext" class="niput" value="" style="position: absolute;width: 30%;left: 0px;text-align: left;top: 80px;z-index: -2;">

	<section id="startPanel">
		<div class="selectPanel">
			<div class="circle start bigger">听数开始</div>
		</div>
	</section>
	<section id="fakePanel">
		<div class="selectPanel">
			<div class="circle bigger">听数开始</div>
		</div>
	</section>
	<section id="endPanel">
		<div class="selectPanel">
			<p>请输入答案</p>
			<input id="answer" type="text" class="niput sxt" value=""
				style="border-bottom: 1px solid #22B26F; width: 60%; margin-bottom: 60px;font-size:25px;" disabled />
			<div class="form_edit clearfix">
				<div class="num">1</div>
				<div class="num">2</div>
				<div class="num">3</div>
				<div class="num">4</div>
				<div class="num">5</div>
				<div class="num">6</div>
				<div class="num">7</div>
				<div class="num">8</div>
				<div class="num">9</div>
				<div id="remove">删除</div>
				<div class="num">0</div>
				<div id="remove" class="end">提交</div>
				</div>
		</div>
	</section>
	<section id="answerPanel" class="white intro" style="display: none;margin-top:15px;">

		<div class="selectPanel" style="margin-top: 0px;padding-top: 20px;">

			<div id="right">
				<i class="fa fa-smile-o fa-3x"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">真棒</span>
			</div>
			<div id="wrong">
				<i class="fa fa-frown-o fa-3x" style="color: #F94082;"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">加油</span>
			</div>
			<div id="answerInput" style="width:40%;margin-left:30%;"></div>
			<div style="border-top: 1px solid black;width: 40%;margin-left: 30%;">
			<input type="text" style="width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;font-size:30px;font-weight:600;" class="niput" value="" disabled=""/>
			<input id="total" type="text" style="width:50%;margin:0;padding:0;font-size:25px;height:40px;text-align:center;padding-right:10%" class="niput sxt" value="" disabled="">
			</div>
<!-- 			<div style="text-align: center; margin: 15px;">
				<input id="next" type="button" class="btn btn-primary start middleBtn"
					value="下一题">
			</div> -->
		</div>


	</section>

	<div id="Result"></div>
	<div id="chart-container">FusionCharts will render here</div>
	<div id="chart-container2">FusionCharts will render here</div>
	<script src="../Jsp/JS/jquery-1.8.0.js"></script>
	<script src="../Jsp/JS/leshu/jQuery.speech.js"></script>
	<script>
		var speed=<%=speed%>;
		var uid='<%=uid%>';
		var level='<%=level%>';
		var category='<%=category%>';
		var text = "开始,";
		var totalTime=0;
		var rightQ=0;
		var wrongQ=0;
		var wrongCollection='<%=wrongCollection%>';
		var wrongIndexArray=new Array();
		var wrongIndex="";
		var answerArray=new Array();

		var questions=null;
		var questionNumber=0;
		var questionObj = null;
		var answers="";
		var tempSequence = 0;

		var batchId=0;
		var sequence=0;
		var index=0;
		var totalQuestion=0;
		
		getQuestions();
		getHistoryQuestion();

		$('.form_edit .num').click(function(){
			var oDiv = $("#answer");
			var answer=oDiv.val()+this.innerHTML;
			oDiv.val(answer);
		})
		$('#remove').click(function(){
			var oDiv = $("#answer");
			var oDivHtml = oDiv.val();
			oDiv.val(oDivHtml.substring(0,oDivHtml.length-1));
		});
		function getQuestions(){
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
				data : {
					category : category
				},
				cache : false,
				success : function(data) {
					if(data){
						questions=data;
						totalQuestion=data.length;
					}
				}
			});
		}
		function getHistoryQuestion(){
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
				data : {
					category : category,
					openid : uid
				},
				cache : false,
				success : function(data) {
					if(data&&data.questionSequence!=0&&data.questionSequence!=null){
						answers=data.answers;
						wrongIndex=data.wrongIndex;
						var b=parseInt(data.batchId);
						var s=parseInt(data.questionSequence);

						answerArray=data.answers.split(",");
						wrongIndexArray=data.wrongIndex.split(",");
						var ts=(b-1)*10+s;
						questionNumber=ts;
					}
				}
			});
		}

		var batchId=0;
		var sequence=0;
		var index=0;
		
		var total = 0;
		function showAnswer(questionNumber) {

			$("#answerInput").html("");
			var questionObj = questions[questionNumber];
			var question = questionObj.question;
			var operator = questionObj.operator;
			var operatorArray = operator.split(",");
			for (var i = 0; i < question.length; i++) {
				if (operatorArray[i] == "+") {

					$("#answerInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;font-size:30px;font-weight:600;' class='niput sxt' value='' disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;font-size:25px;height:40px;text-align:center;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				} else {

					$("#answerInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;font-size:30px;font-weight:600;' class='niput sxt' value="
											+ operatorArray[i]
											+ " disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;font-size:25px;height:40px;text-align:center;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				}
			}
			currentAnswer = questionObj.answer;
			$("#total").val(currentAnswer);
		}
		function findNextQuestion(questionNumber){

			for (var q = 0; q < questions.length; q++) {
				batchId = parseInt(questions[q].batchId);
				sequence = parseInt(questions[q].questionSequence);
				tempSequence = (batchId - 1) * 10 + sequence;
				if (tempSequence == questionNumber) {
					questionObj = questions[q];
					index = q;
					break;
				}
			}

			if(wrongCollection!="yes"){
			if(questionObj==null){
				batchId=Math.floor(questionNumber/10)+1;
				sequence=questionNumber%10;
				answers=answers+"MISS,";
				$.ajax({
					type : "GET",
					url : "../AbacusQuiz/updateHistoryQuiz",
					data : {
						openID : uid,
						category : category,
						batchId : batchId,
						questionSequence : sequence,
						answers : answers
					},
					cache : false,
					success : function(data) {
						if (data) {
						}
					}
				});
				questionNumber++;
				findNextQuestion(questionNumber);
			}
			}
			return questionNumber;
			
		}
		function getNum() {
			
			text = "请听题,";

			$("#questionInput").html("");
			if(questionNumber>totalQuestion){	

				swal({  
		        title:"没有更多的题了，需要重置吗？",  
		        text:"<input type='hidden'>",
		        html:"true",
		        showConfirmButton:"true", 
				showCancelButton: true,   
				closeOnConfirm: false,  
		        confirmButtonText:"是",  
		        cancelButtonText:"否",
		        animation:"slide-from-top"  
		      }, 
				function(inputValue){
					if (inputValue === false){
					$("#processPanel").hide();
					 return false;}
					else{$.ajax({
						type : "GET",
						url : "../AbacusQuiz/updateHistoryQuiz",
						data : {
							openID:uid,
							category : category,
							batchId:1,
							questionSequence:0,
							answers:"",
							wrongIndex:""
						},
						cache : false,
						success : function(data) {
							if(data){
								window.location.href="ShowNumberForBasic.jsp?category="+category+"&UID="+uid;
							}
						}
					});
					}});

				return;
			}
			questionNumber=findNextQuestion(questionNumber);
			var question = questionObj.question;
			var operator = questionObj.operator;
			var operatorArray = operator.split(",");

			for (var i = 0; i < question.length; i++) {
				if (operatorArray[i] == "+") {
					text+=question[i]+",";
				}else
					{
					text+="减"+question[i]+",";
					}
			}
			return text;
		}
		function arrayToString(array){
			var string="";
			for(var i=0;i<array.length-1;i++){
				string +=array[i]+",";
			}
			return string;
		}
		function getWrongNum(num){

			text = "请听题,";
			num=findNextQuestion(num);
			var question = questionObj.question;
			var operator = questionObj.operator;
			var operatorArray = operator.split(",");

			for (var i = 0; i < question.length; i++) {
				if (operatorArray[i] == "+") {
					text+=question[i]+",";
				}else
					{
					text+="减"+question[i]+",";
					}
			}
			return text;
		}
		var yitemp = "";
		function endVoice() {

			$("#fakePanel").hide();
			$("#answerPanel").hide();
			$("#startPanel").hide();
			$("#answerInput").html("");
			$("#endPanel").show();
		};

		$('#Result').speech({
			"speech" : true,
			"speed" : speed,
			"bg" : "./images/speech.png"
		});
		$(".end").on("click", function() {

			var tempIndex=0;
			var answer = $("#answer").val();
			if (answer == "") {
				swal("未答题", "请输入你的答案哦~！", "error");
				return;
			}


			if(wrongCollection!=""&&wrongCollection=="yes"){

				var si=wrongIndexStatic%10;
				var bi=Math.floor(wrongIndexStatic/10)+1;
				showAnswer(index);
				if (answer == currentAnswer) {
					$("#right").show();
					$("#wrong").hide();

					answerArray[wrongIndexStatic-1]=bi+"/"+si+"/"+"1";
					wrongIndexArray.splice(wrongIndexs-1,1);
					var wrongAnswers=arrayToString(answerArray);
					var wrongIndexString=arrayToString(wrongIndexArray);
					$.ajax({
						type : "GET",
						url : "../AbacusQuiz/updateHistoryQuiz",
						data : {
							openID : uid,
							category : category,
							answers : wrongAnswers,
							wrongIndex:wrongIndexString
						},
						cache : false,
						success : function(data) {
							if (data) {
							}
						}
					});
					wrongIndexs=0;
				} else {
					$("#wrong").show();
					$("#right").hide();
				}

				$("#endPanel").hide();
				$("#answerPanel").show();
				setTimeout("wrongStart()",1000);
				
			}else{
			showAnswer(index);
			if (answer == currentAnswer) {
				$("#right").show();
				$("#wrong").hide();
				answers += batchId + "/" + sequence + "/" + "1,";
				rightQ++;
			} else {
				$("#wrong").show();
				$("#right").hide();
				wrongQ++;
				answers += batchId + "/" + sequence + "/" + "0,";
				tempIndex=(batchId-1)*10+sequence;
				wrongIndex += tempIndex+",";
			}
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/updateHistoryQuiz",
				data : {
					openID : uid,
					category : category,
					batchId : batchId,
					questionSequence : sequence,
					answers : answers,
					wrongIndex:wrongIndex
				},
				cache : false,
				success : function(data) {
					if (data) {
					}
				}
			});
			$("#endPanel").hide();
			$("#answerPanel").show();

			setTimeout("fakeClick()",1000);
		}

		});
		function fakeClick(){
			$(".start").click();
		}

		var wrongIndexs=0;
		var wrongIndexStatic=0;
		function wrongStart(){
			$('#Result').html("");

			if(wrongIndexs>=wrongIndexArray.length-1){
				wrongIndexs=0;
			}
			getHistoryQuestion();
			wrongIndexStatic=wrongIndexArray[wrongIndexs];
			wrongIndexs++;
			$("#answer").val("");
			if(wrongIndexStatic==""&&wrongIndexArray.length==1){
				swal("很棒哦~！", "错题都被纠正了！", "success");
				$("#timestext").val(wrongIndexStatic);
				$("#startPanel").hide();
				$("#answerPanel").hide();
				$("#fakePanel").hide();

			}
			else{
				
				$("#timestext").val(wrongIndexStatic);
				$("#startPanel").hide();
				$("#answerPanel").hide();
				$("#fakePanel").show();
				var _iframe = $('#Result').find(".speech_iframe");
				var src = 'http://tts.baidu.com/text2audio?lan=zh&ie=UTF-8&text=' + getWrongNum(wrongIndexStatic) + '&spd='+speed;		
				console.log("getNumber:"+getWrongNum(wrongIndexStatic));
					_iframe.length > 0 ? _iframe.attr("src", src) : (function() {
						var iframe = "<audio controls='' autoplay='' name='media' onended='endVoice()'><source id='voice' src='' type='audio/mp3'></audio>";
						$('#Result').append(iframe);
						$("#voice").attr("src",src);
					})();
			}
		}
		
		$(".exit").on("click", function() {
			if(level=='basic'){
				window.location.href = "NavigatorForBasic.jsp?UID=" + uid;}
			else{
				window.location.href = "Navigator.jsp?UID=" + uid;}
		});
	</script>
</body>
</html>