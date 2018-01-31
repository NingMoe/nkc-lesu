<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%
	int speed = Integer.parseInt(request.getParameter("speed"));
	int numCount = Integer.parseInt(request.getParameter("numCount"));	
	int length=0;
	int lengthMin=0;
	int lengthMax=0;
	String title="";
	if(request.getParameter("length")!=""&&request.getParameter("length")!=null){
		length = Integer.parseInt(request.getParameter("length"));
		title=length+"";
		lengthMax=length;
		lengthMin=length;
	}
	else
	{
		lengthMax = Integer.parseInt(request.getParameter("lengthMax"));
		lengthMin = Integer.parseInt(request.getParameter("lengthMin"));
		title=lengthMin+"-"+lengthMax;
	}
	String uid = request.getParameter("UID");
	String qt= request.getParameter("qt");
	String level="";
	String isExternal="no";
	boolean IsRegistered=false;
	if(uid!=null&&uid!=""){
		HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
		if(res!=null){
			level=res.get("level");
			IsRegistered=MongoDBBasic.checkUserAuth(uid,"IsRegistered");
		}
		else{
			isExternal="yes";
		}
	}
	String display="none";
	if(qt.equals("minute")){
		display="block";
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>乐数-提升级-看算-<%=title %>位</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script src="../Jsp/JS/fusioncharts/fusioncharts.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.widgets.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.theme.fint.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.charts.js"></script>
<link rel="stylesheet" type="text/css"
	href="../Jsp/JS/leshu/bootstrap.min.css" />
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="http://www.jq22.com/jquery/jquery-ui-1.11.0.css">
<link rel="stylesheet"
	href="../Jsp/JS/speedTab/jquery-ui-slider-pips.min.css" />
<script src="../Jsp/JS/speedTab/jquery-plus-ui.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script src="../Jsp/JS/speedTab/jquery-ui-slider-pips.js"></script>
<script src="../Jsp/JS/speedTab/examples.js"></script>
<link rel="stylesheet" href="../Jsp/JS/speedTab/app.min.css" />
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css" />
<script src="../Jsp/JS/leshu/custom.js"></script>
<style type="text/css">
#processPanel,#endPanel,#right,#wrong,#chart-container,#chart-container2 {
	display: none;
}
.form_edit {    
width: 95%;
margin-left: 4%;
}
.sweet-alert{
margin-top:-210px!important;}
.sweet-alert h2{
font-size:28px!important;
}
</style>
</head>
<body>
	<div id="data_model_div" style="height: 110px">
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
<input type="text" id="timetext" class="niput" value="0时0分0秒" style="display:<%=display%>;width: 40%;padding: 0px;position: absolute;top: 80px;right: 10px;text-align: right;background: none;">
	<section id="startPanel">
		<div class="selectPanel">
			<div class="circle start bigger">看数开始</div>
		</div>
	</section>
	<section id="processPanel">
		<div id="questionInput"  style="width:98%;margin-left:1%;margin-top: 0px;padding-top: 20px;padding-bottom:0" class="selectPanel"></div>
		<input style='border-top: 1px solid black;width: 70%;font-size:25px;color:black;' type='text' class='niput sxt' disabled />
	</section>
		<section id="endPanel">
		<div class="selectPanel">
			<p>请输入答案</p>
			<input id="answer" type="text" class="niput sxt" value=""
				style="border-bottom: 1px solid #22B26F; width: 60%; font-size:25px;margin-bottom: 60px;" disabled />
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
		<div class="selectPanel" style="margin-top: 0px;padding-top: 0;">
			<div id="right">
				<i class="fa fa-smile-o fa-3x"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">真棒</span>
			</div>
			<div id="wrong">
				<i class="fa fa-frown-o fa-3x" style="color: #F94082;"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">加油</span>
			</div>
			<div id="answerInput" style="width:98%;margin-left:1%;"></div>
			<div style="border-top: 1px solid black;width: 98%;margin-left: 1%;">
			<input id="totalO" type="text" style="width:40%;font-size:30px;font-weight:600;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;" class="niput" value="" disabled=""/>
			<input id="total" type="text" style="width:50%;font-size:23px;margin:0;padding:0;height:40px;text-align:left;padding-right:10%" class="sxt niput" value="" disabled="">
			</div> 
			<div style="text-align: center; margin: 15px;display:none">
				<input id="next" type="button" class="btn btn-primary start middleBtn"
					value="下一题">
			</div> 
		</div>


	</section>
	<div id="chart-container">FusionCharts will render here</div>
	<div id="chart-container2">FusionCharts will render here</div>
	<script src="../Jsp/JS/jquery-1.8.0.js"></script>
	<script>
	var speed=<%=speed%>;
	var speedArray=new Array(0,10,9,8,7,6,5,4,3,2,1);
	var numCount=<%=numCount%>;
	var lengthMin=<%=lengthMin%>;
	var lengthMax=<%=lengthMax%>;
	var uid='<%=uid%>';
	var level='<%=level%>';
	var IsRegistered=<%=IsRegistered%>;
	var qt='<%=qt%>';
	var rightQ=0;
	var wrongQ=0;
	var totalTime=0;
	var isExternal='<%=isExternal%>';
		var charArray = new Array('-', '+', '+');
		var tempCharArray = new Array();
		var tempArray = new Array();
		var lengthArray = new Array(0, 10, 100, 1000, 10000, 100000, 1000000,
				10000000, 100000000, 1000000000,10000000000);
		
		function hideNum(){
			$("#processPanel").hide();
			$("#endPanel").show();
		}
		$(".start").on("click", function(){
			start();
		});
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
			function start() {
			var tempTime=minute*60+ (millisecond / 1000) + second;
			if($("#next").val()=="查看战绩"){
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
									"value" :tempTime
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
				                "caption": "看算正误统计",
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
				                            "label": "看算"
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
				$("#next").val("下一题");

				$("#answerPanel").hide();
				$("#startPanel").show();
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
										"value" :tempTime
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
					                "caption": "看算正误统计",
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
					                            "label": "看算"
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
					reset();
					totalTime=0;
				return;
				}
			}
			getNum();
			totalTime++;
			if(qt=="question"){
				$("#timestext").val(totalTime+"/10");
			}else if(qt=="minute"){
				$("#timestext").val("第"+totalTime+"题");
			}
			$("#answerPanel").hide();
			$("#startPanel").hide();
			$("#processPanel").show();
			setTimeout("hideNum()",speedArray[speed]*300);
		};

		var charQ = 0;
		var chars;
		var tempTotal = 0;
		function count(chara, oldNumer, newNumber) {
			var result;
			if (chara == '+') {
				result = oldNumer + newNumber;
			} else {

				result = oldNumer - newNumber;
			}
			return result;
		}

		var operatorL="";
		var numberL="";
		if(lengthMax>5){
			operatorL="20%";
			numberL="70%";
			$("#totalO").css("width","20%");
			$("#total").css("width","70%");
		}else{
			operatorL="40%";
			numberL="50%";
		}
		function getNum() {
			$("#questionInput").html("");
			var temp = 0;
			for (var i = 0; i < numCount; i++) {
					temp = Math.floor(Math.random()
							* (lengthArray[lengthMax] - lengthArray[lengthMin - 1])
							+ lengthArray[lengthMin - 1]);
					if(temp==0){
						temp=1;
					}
				if (i != 0) {
					charQ = Math.round(Math.random() * (charArray.length - 1));
					chars = charArray[charQ];
					tempCharArray[i] = chars;
					if (chars == '-') {
						if (tempTotal - temp < 0) {

							tempCharArray[i] = '+';
						}
						tempArray[i] = temp;
					} else {
						tempArray[i] = temp;
					}

					tempTotal = count(tempCharArray[i], tempTotal, tempArray[i]);
				} else {
					tempCharArray[0] = "+";
					tempArray[0] = temp;
					tempTotal = temp;
				}
				var tempString=temp+"";
				var length=tempString.length;
				for(var z=0;z<lengthMax-length+1;z++){
					tempString='&nbsp;&nbsp;'+tempString;
				}
				var c=tempCharArray[i];
				if(c=="+"){

					$("#questionInput")
							.append(
									"<input type='text' style='width:"+operatorL+";font-size:30px;font-weight:600;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;' class='niput sxt' value='' disabled />"
											+ "<input type='text' style='width:"+numberL+";font-size:23px;margin:0;padding:0;height:40px;text-align:left;padding-right:10%' class='niput sxt' value="
											+ tempString + " disabled />");
				}
				else{

					$("#questionInput")
							.append(
									"<input type='text' style='width:"+operatorL+";font-size:30px;font-weight:600;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;' class='niput sxt' value="
											+ c
											+ " disabled />"
											+ "<input type='text' style='width:"+numberL+";font-size:23px;margin:0;padding:0;height:40px;text-align:left;padding-right:10%' class='niput sxt' value="
											+ tempString + " disabled />");
				}

			}
		}

		var total = 0;
		function showAnswer() {
			var tempString="";
			var length=0;
			$("#answerInput").html("");
			for (var i = 0; i < numCount; i++) {

				tempString=tempArray[i] .toString();
				length=tempString.length;
				for(var z=0;z<lengthMax-length+1;z++){
					tempString='&nbsp;&nbsp;'+tempString;
				}
				var c=tempCharArray[i];
				if(c=="+"){
				$("#answerInput")
						.append(
								"<input type='text' style='width:"+operatorL+";font-size:30px;font-weight:600;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;' class='niput sxt' value='' disabled />"
										+ "<input type='text' style='width:"+numberL+";font-size:23px;margin:0;padding:0;height:40px;text-align:left;padding-right:10%' class='niput sxt' value="
										+ tempString + " disabled />");
				}
				else{
					$("#answerInput")
					.append(
							"<input type='text' style='width:"+operatorL+";font-size:30px;font-weight:600;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;' class='niput sxt' value="
									+ c
									+ " disabled />"
									+ "<input type='text' style='width:"+numberL+";font-size:23px;margin:0;padding:0;height:40px;text-align:left;padding-right:10%' class='niput sxt' value="
									+ tempString + " disabled />");
				}
			}

			tempString=tempTotal.toString();
			length=tempString.length;
			for(var z=0;z<lengthMax-length+1;z++){
				tempString=' '+tempString;
			}
			$("#total").val(tempString);

		}
		$(".end").on("click", function() {

			var answer = $("#answer").val();
			if (answer == "") {
				swal("未答题", "请输入你的答案哦~！", "error");
				return;
			} 
			if(qt=="question"&&totalTime==10){
				$("#next").val("查看战绩");
				timeStop();

			}

			showAnswer();
			if (answer == tempTotal) {
				$("#right").show();
				$("#wrong").hide();
				rightQ++;
			} else {
				$("#wrong").show();
				$("#right").hide();
				wrongQ++;
			}

			$("#processPanel").hide();
			$("#endPanel").hide();
			$("#answerPanel").show();

			setTimeout("start()",1000);

		});
		$(".exit").on("click", function() {
			if(level=='basic'){
				window.location.href = "NavigatorForBasic.jsp?UID=" + uid;}
			else{
				window.location.href = "Navigator.jsp?UID=" + uid;}
		});
	</script>
</body>
</html>