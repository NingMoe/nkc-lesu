<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- saved from url=(0118)http://wxe542e71449270554.dodoca.com/164368/phonewebsitet/websitet?uid=164368&openid=FANS_ID&id=99315#mp.weixin.qq.com -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>乐数珠心算</title>
<meta name="Keywords" content="乐数珠心算">
<meta name="Description" content="专注4-12岁幼儿珠心算培训">

<!-- 移动设备支持 -->

<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
<meta content="no-cache" http-equiv="pragma">
<meta content="0" http-equiv="expires">
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> 
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

<link href="../Jsp/CSS/reset.css" rel="stylesheet" type="text/css">
<link href="../Jsp/CSS/mod33.css" rel="stylesheet" type="text/css">
<!-- <script type="text/javascript" src="./乐数珠心算_files/jquery-1.10.2.min.js.download"></script> -->

</head>

<body>

  <div class="mod_main ">
    <div id="bg_img" style="background: url(&#39;http://p1.dodoca.com/org/9/ac/cd9/ac52/c06df42088ca6978ef8924.jpg&#39;);background-size:100%;"></div>
   <div class="mod_menu">
<a href="http://leshucq.bceapp.com/mdm/leshuintro/agentintro.html" onclick="tongji(522995,0);" style="background-color:rgba(30, 127, 196, 0.75);color:#ffffff;">
	<i>
		<img src="../mdm/images/leshu/19fc7f99cfe9bb301a0a5a.png" class="contentimgcl">
	</i>
    <span>学校简介</span>
</a>
<a href="http://leshucq.bceapp.com/mdm/leshuintro/courseintro.html" onclick="tongji(522996,0);" style="background-color:rgba(30, 127, 196, 0.75);color:;">
	<i>
		<img src="../mdm/images/leshu/2804b4c496054f7a0d51fa.png" class="contentimgcl">
	</i>
    <span>课程介绍</span>
</a>
<a href="http://leshucq.bceapp.com/mdm/leshuintro/activitymoment.html" onclick="tongji(522997,0);" style="background-color:rgba(30, 127, 196, 0.75);color:;">
	<i>
	        <img src="../mdm/images/leshu/79679c52ee0a82607843df.png" class="contentimgcl">
	</i>
    <span>活动剪影</span>
</a>
<a href="http://leshucq.bceapp.com/mdm/leshuintro/leshustudent.html" onclick="tongji(523000,0);" style="background-color:rgba(30, 127, 196, 0.75);color:;">
	<i>
	     	<img src="../mdm/images/leshu/bf5c670aed4fc0e4bbc1f0.png" class="contentimgcl">
	</i>
    <span>学员风采</span>
</a>
<a href="http://leshucq.bceapp.com/mdm/leshuintro/leshuteacher.html" onclick="tongji(523000,0);" style="background-color:rgba(30, 127, 196, 0.75);color:;">
	<i>
	     	<img src="../mdm/images/leshu/bf5c670aed4fc0e4bbc1f0.png" class="contentimgcl">
	</i>
    <span>乐数师资</span>
</a>
<a href="http://leshucq.bceapp.com/mdm/leshuintro/questionanswer.html" onclick="tongji(524311,0);" style="background-color:rgba(30, 127, 196, 0.75);color:;">
	<i>
	        <img src="../mdm/images/leshu/b119bc7a3f1e39e8b92e14.png" class="contentimgcl">
	</i>
    <span>常见问题</span>
</a>
          </div>
  </div>



  <script type="text/javascript" src="./乐数珠心算_files/jweixin-1.0.0.js.download"></script>
<script type="text/javascript" src="./乐数珠心算_files/wxsharejs.js.download"></script><script type="text/javascript" src="./乐数珠心算_files/jquery-1.10.2.min.js.download"></script>
<!-- <script type="text/javascript" src="/www/js/wxsharejs.js"></script> -->
<script type="text/javascript">

	var tongjitype = $.trim(2);
	var uid = $.trim(164368);
	function tongji(id,type){
		$.ajax({
			url:"/164368/phonewebsite/tongji",
			type:"post",
			async:false,
			data:{'id':id,'type':type,'tongjitype':tongjitype,'uid':uid}		
		})
	}
	var fx_describefenxiang = "";
	wx_share_out('乐数珠心算','',fx_describefenxiang);
</script>	<!-- 如果微巴帐号 -->
			<a href="http://leshucq.bceapp.com/mdm/LeShuIntro.jsp">
			<footer>
				重庆乐数珠心算			</footer>
		</a>
		






<!--音乐-->
  <div id="audio_btn" url=""></div>

<script>


</script>

<script>

$(function(){
	if (typeof WeixinJSBridge == "undefined"){
		if( document.addEventListener ){
			document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
		}else if (document.attachEvent){
			document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
			document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
		}
	}else{
		onBridgeReady();
	}

	var shareTitle = '乐数珠心算';
	var imgUrl = "0";
	var descContent = $("#div_fx_describe").text();
	wx_share_out('164368',shareTitle,imgUrl,descContent);
})

function onBridgeReady(){
     WeixinJSBridge.call('showOptionMenu');
}
</script>
<div id="div_fx_describe" style="display:none;"></div>




    <!--底部导航-->
<style>
.plug-menu span { display: block; width: 28px; height: 28px; background: url(/www/images/mod/custom/xiangyu/link/icon-main.png) no-repeat; background-size: 28px 28px; text-indent: -999px; position: absolute; top: 50%; left: 50%; margin-top: -14px; margin-left: -14px; overflow: hidden; }
#audio_btn{position: fixed;right: 10px;top: 10px;z-index: 200;display: none;width: 30px;height: 30px;background-image: url(/www/images/modt/audio.png);background-repeat: no-repeat;background-size: 30px 60px;background-position: 0px 0px;}
</style>
  
<input type="hidden" id="ifthird" value="">
<script>
  $(function(){
      //快捷菜单
      var mune_x = $(window).width() - 46,mune_y = $(window).height() - 46;
      
      if($('#ifthird').val()=='1'){
        $('#plug-phone').attr("style","left:"+mune_x+"px;top:"+mune_y+"px;position:fixed;");
      }else{
        $("#plug-phone").css({left:mune_x,top:mune_y});
      } 
      $(".plug-menu").click(function(){
         var span = $(this).find("span");
          if(span.attr("class") == "open"){
                span.removeClass("open");
                span.addClass("close");
                $(".plug-btn").removeClass("open");
                $(".plug-btn").addClass("close");
          }else{
                span.removeClass("close");
                span.addClass("open");
                $(".plug-btn").removeClass("close");
                $(".plug-btn").addClass("open");
          }
      });
      
      var obj = document.getElementById('plug-menu');
      if(obj && $('#ifthird').val()==""){
        obj.addEventListener('touchmove', function(event) {
          if (event.targetTouches.length == 1) {
      　　　　 event.preventDefault();
              var touch = event.targetTouches[0];
              // 把元素放在手指所在的位置
          x = touch.pageX-18;
          y = touch.pageY-18;
          $("#plug-phone").css({left:x,top:y}); 
              }
         }, false);
      }

  })

</script>

</body></html>