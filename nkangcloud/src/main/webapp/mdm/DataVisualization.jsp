<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.RestUtils"%>
<%@ page import="com.nkang.kxmoment.baseobject.ArticleMessage"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>

<%	
/* List<ArticleMessage> BJtitles =MongoDBBasic.getArticleMessageByType("bj");
int BJTotalNum=BJtitles.size(); */

List<String> dates=MongoDBBasic.getLastestDate(-6);
ArrayList<Map> visitedPageList=MongoDBBasic.QueryVisitPageAttention();
List<List<Integer>> visitedList=new ArrayList<List<Integer>>();
for(int i=0;i<visitedPageList.size();i++){
	visitedList.add(MongoDBBasic.getTotalVisitedNumByPage(dates,visitedPageList.get(i).get("realName").toString()));
}
/* List<Integer> scanNumList=MongoDBBasic.getTotalVisitedNumByPage(dates,"scan");
List<Integer> profileNumList=MongoDBBasic.getTotalVisitedNumByPage(dates,"profile");
List<Integer> quoteNumList=MongoDBBasic.getTotalVisitedNumByPage(dates,"quoteDetailExternal");
 */
MongoDBBasic.addSkimNum();
%> 
<!DOCTYPE html>
<html><head lang="en"><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>来访分析</title>
    <link href="../Jsp/JS/pizzaChart/css/app.css" media="screen, projector, print" rel="stylesheet" type="text/css" />
<link href="../Jsp/JS/pizzaChart/css/pizza.css" media="screen, projector, print" rel="stylesheet" type="text/css" />
<script src="../Jsp/JS/pizzaChart/js/custom.modernizr.js"></script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css"/>
<script type="text/javascript" src="../nkang/jquery-1.8.0.js"></script>
<script	src="../MetroStyleFiles/sweetalert.min.js"></script>
<style>
p{
margin-bottom:0px;
}
#svg2 svg{
width:70%;
height:240px;
margin-left:15%;}
ul li{
border-top:1px solid #F0F0F0;
border-bottom:1px solid #F0F0F0;
height:40px;
line-height:40px;
}
.text-left{
display: block;
width:60%;
text-align:left!important;
float:left;
padding-left:10px;
}
.text-right{
display: block;
width:40%;
text-align:right!important;
float:left;
padding-right:10px;
}
.arrow{
position:absolute;
top:-13px;
width:6%;
left:47%;
z-index:1000;
}
#detailPanel{
height:300px;
width:100%;
}
.title{
    display: block;
    margin-left: 10px;
    font-size: 13px;
    color: #d3d3d3;
    height: 40px;
	margin-top:-15px;
	line-height:45px;}
.singleArticle{
width:100%;
height:50px;
font-size:14px;
border-bottom:1px solid #F0F0F0;
position:relative;
}
.singleArticle span
{ 
    position: absolute;
    z-index: 1000;
    top: 17px;
    right: 15px;
    font-size: 14px;
    color: #d3d3d3;

}
.singleArticle p
{
line-height:50px;
float:left;
height:100%;
}

.rank{
width:20%;
text-align:center;
font-size:20px;
color:orange;
}
.at{
width:80%;
color:#9A9A9A;
font-weight:bold;
}
/*
#HQdetail .rank,#HQdetail .at
{
  color: #FFC444;
}
#JSdetail .rank,#JSdetail .at
{
  color: #FF9A38;
}
#BJdetail .rank,#BJdetail .at
{
  color: #FFD427;
}
#GTdetail .rank,#GTdetail .at
{
  color: #EA4E2F;
}*/

#menu
{
    height: 30px;
    width: 70%;
    margin-left: 15%;
    border: 1px solid black;
    margin-top: 20px;
    border-radius: 5px;
	font-size:14px;
	overflow:hidden;
}
#menu p
{
width:100%;
height:100%;
float:left;
text-align:center;
line-height:30px;
border-left:1px solid black;
}
.selected
{
background-color:black;
color:white;
}
#quotationList
{

    margin-top: 10px;
    border-top: 1px solid #D3D3D3;
    width: 100%;
    overflow: scroll;

}
.singleQI {
    height: 45px;
    width: 100%;
    border-bottom: 1px solid #D3D3D3;
    position:relative;
    cursor:pointer;
}

.singleQI span
{
    height: 100%;
    line-height: 45px;
    padding-left: 20px;
    font-size: 15px;
    font-weight:bold;
}
.singleQI img
{
 position: absolute;
    z-index: 1000;
    top: 15px;
    right: 15px;
    width:10px;
}
#chart-container
{
display:none;
}
.singleV{
    height: 45px;
    border-bottom: 1px solid #F0F0F0;
    width: 100%;
    position:relative;
}
.singleV img{
    border-radius: 25px;
    height: 35px;
    width: 35px;
    position: absolute;
    top: 5px;
    left: 20px;
}
.VNickName{
    width: 30%;
    margin-left: 18%;
    height: 100%;
    font-size: 14px;
    line-height: 45px;
    float: left;
        color: #9A9A9A;
}
.visitedNum{
    width: 47%;
    margin-right: 5%;
    float: left;
    line-height: 45px;
    text-align: right;
        font-size: 14px;
    color: #d3d3d3;
}
.visitedMenu
{
height: 30px;
border-bottom:1px solid #f0f0f0;
width:100%;
text-align: center;
margin-bottom: 5px;
}
.visitedMenu p
{
 height: 30px;
 width: 15%;
 border:1px solid #f0f0f0;
 border-bottom:none;
 border-radius: 6px 6px 0px 0px;
 line-height: 30px;
 font-size: 14px;
 float: left;
}
.active
{
background-color: white;
}
</style>
    	<script type="text/javascript" src="../Jsp/JS/fusioncharts.js"></script>
    	<script type="text/javascript" src="../Jsp/JS/fusioncharts.powercharts.js"></script>
	<script type="text/javascript" src="../Jsp/JS/fusioncharts.theme.fint.js"></script>

<!--     <script>
    FusionCharts.ready(function () {
        var estProcChart = new FusionCharts({
            type: 'errorline',
            renderAt: 'chart-container',
            width: '380',
            height: '350',
            dataFormat: 'json',
            dataSource: {
                "chart": {
                    "theme": "fint",
                    "xaxisname": "ABS-02152A",
                    "yaxisname": "",
                    "numberSuffix":"",
                    "caption": "ABS价格变化",
                    "subcaption": "(02152A)",
                    "showvalues": "0",
                    "plottooltext": "$seriesname, $value",
                    //Error bar configuration
                    "halferrorbar": "0",
                    "errorBarColor": "#990000",
                    "errorBarAlpha": "50",
                    "errorBarThickness": "4",
                    "errorBarWidth": "8"
                },
                "categories": [
                    {
                        "category": [
                            { "label": "Jan" },
                            { "label": "Feb" }, 
                            { "label": "Mar" },
                            { "label": "Apl" },
                            { "label": "May" },
                            { "label": "Jun" }, 
                            { "label": "Jul" },
                            { "label": "Aug" },
                            { "label": "Sep" },
                            { "label": "Oct" }, 
                            { "label": "Nov" },
                            { "label": "Dec" }
                        ]
                    }
                ],
                "dataset": [
                    {
                        "seriesname": "定价",
                        "data": [
                            {
                                "value": "16700",
                                "errorvalue": "50"
                            }, 
                            {
                                "value": "16750",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16700",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16900",
                                "errorvalue": ""
                            },
                            {
                                "value": "16700",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16750",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16700",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16900",
                                "errorvalue": ""
                            }
                            ,
                            {
                                "value": "16700",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16750",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16700",
                                "errorvalue": ""
                            }, 
                            {
                                "value": "16900",
                                "errorvalue": ""
                            }
                        ]
                    }, {
                        "seriesname": "发布价",
                        "data": [
                                 {
                                     "value": "16300",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "16950",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17000",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17300",
                                     "errorvalue": ""
                                 },
                                 {
                                     "value": "16300",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "16950",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17000",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17300",
                                     "errorvalue": ""
                                 },
                                 {
                                     "value": "16300",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "16950",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17000",
                                     "errorvalue": ""
                                 }, 
                                 {
                                     "value": "17300",
                                     "errorvalue": ""
                                 }
                        ]
                    }
                ]
            }
        }).render();
        
    });
    </script> -->
</head>
<body>
<div style="padding-left: 10px;height: 70px;border-bottom: 4px solid #20b672;padding-top: 10px;">
<img src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" class="HpLogo" style="display: inline !important; height:50px; float: none; padding: 0px; vertical-align: bottom;">
</div>


<div id="quoteVisited">
<div id="chart-container2"></div>
<div class="visitedMenu">
    <p id="read" class="active">已读</p><p style="border:none;width:27%" id="dateDetail" style="border-left: none;width:20%;"></p>
</div>
<div id="visitedDetail" style="display:none;"></div>

</div>


<script>
    $(function(){
      
$("svg path").live("click",function(){
var i=$(this).index();
	 console.log($(this).index()/2);
	  $("ul li:nth-child("+i/2+")").show();
	  $("ul li:nth-child("+i/2+")").siblings().hide();
	  var j=i/2+1;
	  $("div#detailPanel .commonPanel:nth-child("+j+")").show();
	   $("div#detailPanel .commonPanel:nth-child("+j+")").siblings(".commonPanel").hide();

	  
    });
		  FusionCharts.ready(function () {
		        var estProcChart = new FusionCharts({
		            type: 'errorline',
		            renderAt: 'chart-container2',
		            width: '380',
		            height: '350',
		            dataFormat: 'json',
		            dataSource: {
		                "chart": {
		                    "theme": "fint",
		                    "xaxisname": "",
		                    "yaxisname": "",
		                    "numberSuffix":"",
		                    "caption": "阅读统计",
		                    "subcaption": "(最近七天访问量)",
		                    "showvalues": "0",
		                    "plottooltext": "$seriesname, $value",
		                    //Error bar configuration
		                    "halferrorbar": "0",
		                    "errorBarColor": "#990000",
		                    "errorBarAlpha": "50",
		                    "errorBarThickness": "4",
		                    "errorBarWidth": "8"
		                },
		                "categories": [
		                    {
		                        "category": [
		                             <%  for(int i=0;i<dates.size();i++){ 
		                            	 if(i==dates.size()-1){%>
		                            	 { "label":" <%=dates.get(i)%>" }
		                            	 <%}else{%>
		                            { "label": "<%=dates.get(i)%>" },
		                            <%}%>
		                            <%}%>
		                            
		                        ]
		                    }
		                ],
		                "dataset": [
		                <% for(int i=0;i<visitedList.size();i++){%>
		                    {
		                        "seriesname": "<%=visitedPageList.get(i).get("descName").toString()%>",
		                        "data": [
		                                 <%  for(int j=0;j<visitedList.get(i).size();j++){ 
			                            	 if(i==visitedList.get(i).size()-1){%>
			                            	 {
			                                     "value": "<%=visitedList.get(i).get(j)%>",
			                                     "errorvalue": ""
			                                 }
			                            	 <%}else{%>
			                            	 {
			                                     "value": "<%=visitedList.get(i).get(j)%>",
			                                     "errorvalue": ""
			                                 },
			                            <%}%>
			                            <%}%>
		                                
		                        ]
		                    }
		                    <% if(i<visitedList.size()-1){%>, <%}%>
		                    <% }%>
		                ]
		            }
		        }).render();
		        
		    });
		  
	$("#chart-container2").show();
	$("#chart-container2 circle").css("cursor","pointer");

	 $(document).on("click","#chart-container2 circle",function(){
		 console.log("....."+$(this).index());
		 var index=$(this).index();
		 
		 var detail=$("#fusioncharts-tooltip-element").children("span").text();
		 var details=detail.split(",");
	 	 $.ajax({
				type : "post",
				async: false,
				url : "../getVisitedDetail",
				data:{
					pageName:details[0],
					dateIndex:index
				},
				cache : false,
				success : function(data) {
					if(data){
					var html="";
					var imgUrl="";
					var sharedNum="";
				for(var i=0;i<data.length;i++)
				{
					console.log("date========"+data[i].date);
					console.log("nickName========"+data[i].nickName);
					console.log("imgUrl========"+data[i].imgUrl);
					imgUrl=data[i].imgUrl;
					if(data[i].visitedNum!=0&&imgUrl!="null")
					{	
						if(data[i].sharedNum!=0){
							sharedNum="<span onclick='getDetailedShare(\""+data[i].openid+"\",\""+data[i].date+"\",\""+data[i].pageName+"\",\""+data[i].nickName+"\")'>("+data[i].sharedNum+")</span>";
						}
						html+="<div class='singleV'><img src='"+data[i].imgUrl+"' /><p class='VNickName'>"+data[i].nickName+"</p><p class='visitedNum'>"+data[i].visitedNum+sharedNum+"</p></div>";
					};
					sharedNum="";
				}
				$("#dateDetail").text(data[0].date);
				$("#visitedDetail").html(html);
				$("#visitedDetail").show();
				$("#read").addClass("active");
					}
		 }
				
		 }); 
		
	 });

	$("#read").on("click",function(){
		$("#visitedDetail").show();
		$("#read").addClass("active");
		
	});


	  
	  });
	function getDetailedShare(openid,date,pageName,nickName){
		$.ajax({
			type : "post",
			async: false,
			url : "../getSharedDetail",
			data:{
				openid:openid,
				date:date,
				pageName:pageName,
				nickName:nickName
			},
			cache : false,
			success : function(data) {
				if(data){
					var sharedList="<div style='height:200px;overflow:scroll'>";
					for(var i=0;i<data.length;i++){
	  	        		sharedList+="<p style='width:100%;float:left;height:40px;line-height:40px;text-align: center;'>"+data[i]+"</p>";
	  	        		}
					sharedList+="</div>";
	  	  		 swal({  
	  			        title:"分享列表",  
	  			        text:sharedList,
	  			        html:"true",
	  			        showConfirmButton:false, 
	  					showCancelButton: true,   
	  					closeOnConfirm: false,   
	  			        cancelButtonText:"关闭",
	  			        confirmButtonColor: "#000",
	  			        animation:"slide-from-top"  
	  			      }, 
	  					function(inputValue){
	  			    	  if (inputValue === false){ return false; }
	  			      }
	  			     );
				}
			
			}
		});
	}
		
  </script>
</body></html>