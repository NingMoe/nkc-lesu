﻿﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.GeoLocation"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.WeChatUser"%>
<%@ page import="com.nkang.kxmoment.baseobject.ClientMeta"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String AccessKey = RestUtils.callGetValidAccessKey();
String uid = request.getParameter("UID");
MongoDBBasic.updateUser(uid);
String name = "";
String phone = "";
String headImgUrl ="";
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
if(res!=null){
	if(res.get("HeadUrl")!=null){
		headImgUrl=res.get("HeadUrl");
	}
	if(res.get("NickName")!=null){
		name=res.get("NickName");
	}
	if(res.get("phone")!=null){
		phone=res.get("phone");
	}
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit"/>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <link rel="stylesheet" href="global-wap.css">
    <script src="global-wap.js"></script>
    <script type="text/javascript">
      seajs.config({
          base: '//images.koolearn.com/shark/',
          importBase: '//images.koolearn.com/shark/',
          comboExcludes: function(uri) {
              return true
          }
      });
    </script>
    <title>乐数珠心算移动端自测</title>
    <meta name="keywords" content="乐数珠心算移动端自测" />
    <meta name="description" content="乐数珠心算移动端自测" />
    <link rel="stylesheet" href="style.css" />
    <script type="text/javascript" src="wap-resize.js"></script>
    <script type="text/javascript" src="lodash.js"></script>
    <script type="text/javascript" src="vue.js"></script>
    <script>
        document.domain = 'leshucq.bceapp.com';
    </script>
</head>
<body>
<div class="i-base-wrap">
    <div id="ji-header" class="i-header">
        <div class="fl">
            <img src="https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EG8wW&oid=00D90000000pkXM" height="51" width="100">
        </div>

        <a class="i_name fl" href="#">乐在其中  心中有数</a>

        <div class="fr">
<!--             <div id="i-header-info" class="header-rc i-head-login"> -->
            <div >
                <span class="username colorBlue" id="username" style="color:white;">欢迎您：<%=name %></span><br />
                <a style="float: right;" href="http://leshucq.bceapp.com/mdm/profile.jsp?UID=<%= uid%>"> <img id="userImage" src="<%=headImgUrl %>" alt="userImage" class="userImage" style="border-radius: 25px; height: 35px; width: 35px;"></a></span>
            </div>	
        </div>
    </div>
</div>
<div id="content_data" style="display: none">
<div class="item">
        <p class="item_name">少儿珠算</p>
        <ul class="sub_item">
            <li paper-id="53305">启蒙班</li>
            <li paper-id="53306">初级班</li>
            <li paper-id="53307">中级班</li>
            <li paper-id="53308">提高班</li>
            <li paper-id="53309">精英班</li>
        </ul>
        <div class="kb" title="我的课表安排" more="">
            <ul class="kb_item" title="级别" >
                <li>
                    <span class="class-name">启蒙班</span>
                    <span class="class-time">490</span>
                    <span class="class-price">1980</span>
                    <span class="class-src">../mdm/ListenNumber.jsp</span>
                </li>
                <li>
                    <span class="class-name">初级班</span>
                    <span class="class-time">437</span>
                    <span class="class-price">1980</span>
                    <span class="class-src">../mdm/ShowNumber.jsp</span>
                </li>
				<li>
                    <span class="class-name">中级班</span>
                    <span class="class-time">384</span>
                    <span class="class-price">1980</span>
                    <span class="class-src">http://m.koolearn.com/product/47052_1.html</span>
                </li>
				<li>
                    <span class="class-name">提高班</span>
                    <span class="class-time">357</span>
                    <span class="class-price">1980</span>
                    <span class="class-src">http://m.koolearn.com/product/47030_1.html</span>
                </li>
                <li>
                    <span class="class-name">精英班</span>
                    <span class="class-time">357</span>
                    <span class="class-price">1980</span>
                    <span class="class-src">http://m.koolearn.com/product/47030_1.html</span>
                </li>
            </ul>
        </div>
    </div>
	<div class="item">
        <p class="item_name">少儿心算</p>
        <ul class="sub_item">
            <li paper-id="53336">启蒙班</li>
            <li paper-id="53337">初级班</li>
            <li paper-id="53338">中级班</li>
            <li paper-id="53333">提高班</li>
            <li paper-id="53334">精英班</li>
        </ul>
        <div class="kb" title="我的课程安排" more="">
            <ul class="kb_item" title="级别" >
                <li>
                    <span class="class-name">启蒙班</span>
                    <span class="class-time">146</span>
                    <span class="class-price">1680</span>
                    <span class="class-src">http://m.koolearn.com/product/47149_1.html</span>
                </li>
                <li>
                    <span class="class-name">初级班</span>
                    <span class="class-time">146</span>
                    <span class="class-price">1480</span>
                    <span class="class-src">http://m.koolearn.com/product/47150_1.html</span>
                </li>
                <li>
                    <span class="class-name">中级班</span>
                    <span class="class-time">73</span>
                    <span class="class-price">1200</span>
                    <span class="class-src">http://m.koolearn.com/product/47151_1.html</span>
                </li>
                <li>
                    <span class="class-name">提高班</span>
                    <span class="class-time">73</span>
                    <span class="class-price">1200</span>
                    <span class="class-src">http://m.koolearn.com/product/47151_1.html</span>
                </li>
                <li>
                    <span class="class-name">精英班</span>
                    <span class="class-time">73</span>
                    <span class="class-price">1200</span>
                    <span class="class-src">http://m.koolearn.com/product/47151_1.html</span>
                </li>
            </ul>
        </div>
    </div>
	<div class="item">
        <p class="item_name">丫丫拼音</p>
        <ul class="sub_item">
            <li paper-id="53318">丫丫拼音</li>
            <li paper-id="53322">丫丫拼音</li>
            <li paper-id="53326">丫丫拼音</li>
        </ul>
        <div class="kb" title="分类" more="">
            <ul class="kb_item" title="丫丫拼音" >
                <li>
                    <span class="class-name">丫丫拼音</span>
                    <span class="class-time">105</span>
                    <span class="class-price">1100</span>
                    <span class="class-src">http://m.koolearn.com/product/45760_1.html</span>
                </li>
                <li>
                    <span class="class-name">丫丫拼音</span>
                    <span class="class-time">108</span>
                    <span class="class-price">550</span>
                    <span class="class-src">http://m.koolearn.com/product/45762_1.html</span>
                </li>
                <li>
                    <span class="class-name">丫丫拼音</span>
                    <span class="class-time">83</span>
                    <span class="class-price">350</span>
                    <span class="class-src">http://m.koolearn.com/product/45765_1.html</span>
                </li>
            </ul>

			<ul class="kb_item" title="少儿机器人" >
                <li>
                    <span class="class-name">少儿机器人</span>
                    <span class="class-time">280</span>
                    <span class="class-price">800</span>
                    <span class="class-src">http://m.koolearn.com/product/45781_1.html</span>
                </li>
                <li>
                    <span class="class-name">少儿机器人</span>
                    <span class="class-time">280</span>
                    <span class="class-price">650</span>
                    <span class="class-src">http://m.koolearn.com/product/45782_1.html</span>
                </li>
                <li>
                    <span class="class-name">少儿机器人</span>
                    <span class="class-time">184</span>
                    <span class="class-price">450</span>
                    <span class="class-src">http://m.koolearn.com/product/45783_1.html</span>
                </li>
            </ul>
        </div>
    </div>
	<div class="item">
        <p class="item_name">建筑工程</p>
        <ul class="sub_item">
            <li paper-id="53327">施工员</li>
            <li paper-id="53328">安全员</li>
            <li paper-id="53329">材料员</li>
            <li paper-id="53330">质检员</li>
            <li paper-id="53331">资料员</li>
            <li paper-id="53332">标准员</li>
        </ul>
        <div class="kb" title="建筑工程选课中心" more="">
            <ul class="kb_item" title="类别" >
                <li>
                    <span class="class-name">施工员</span>
                    <span class="class-time">基础知识、岗位实务</span>
                    <span class="class-price">750</span>
                    <span class="class-src">http://m.koolearn.com/product/45846_1.html</span>
                </li>
                <li>
                    <span class="class-name">安全员</span>
                    <span class="class-time">基础知识、岗位实务</span>
                    <span class="class-price">1000</span>
                    <span class="class-src">http://m.koolearn.com/product/45849_1.html</span>
                </li>
                <li>
                    <span class="class-name">资料员</span>
                    <span class="class-time">实战</span>
                    <span class="class-price">3200</span>
                    <span class="class-src">http://m.koolearn.com/product/45831_1.html</span>
                </li>
                <li>
                    <span class="class-name">资料员</span>
                    <span class="class-time">精品班</span>
                    <span class="class-price">4600</span>
                    <span class="class-src">http://m.koolearn.com/product/45831_1.html</span>
                </li>
                <li>
                    <span class="class-name">质检员</span>
                    <span class="class-time">基础知识、岗位实务</span>
                    <span class="class-price">1000</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                <li>
                    <span class="class-name">材料员</span>
                    <span class="class-time">82</span>
                    <span class="class-price">850</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                <li>
                    <span class="class-name">标准员</span>
                    <span class="class-time">80</span>
                    <span class="class-price">980</span>
                    <span class="class-src">http://m.koolearn.com/product/45858_1.html</span>
                </li>
            </ul>
        </div>
    </div>
    
    <div class="item">
        <p class="item_name">建筑工程</p>
        <ul class="sub_item">
            <li paper-id="53327">造价员</li>
            <li paper-id="53328">试验员</li>
            <li paper-id="53329">劳务员</li>
            <li paper-id="53330">预算员</li>
            <li paper-id="53331">测量员</li>
            <li paper-id="53332">机械管理员</li>
        </ul>
        <div class="kb" title="建筑工程选课中心" more="">
            <ul class="kb_item" title="类别" >
                <li>
                    <span class="class-name">造价员</span>
                    <span class="class-time">实战班</span>
                    <span class="class-price">4200</span>
                    <span class="class-src">http://m.koolearn.com/product/45846_1.html</span>
                </li>
                <li>
                    <span class="class-name">造价员</span>
                    <span class="class-time">精品班</span>
                    <span class="class-price">4800</span>
                    <span class="class-src">http://m.koolearn.com/product/45846_1.html</span>
                </li>
                <li>
                    <span class="class-name">造价员</span>
                    <span class="class-time">综合班</span>
                    <span class="class-price">5200</span>
                    <span class="class-src">http://m.koolearn.com/product/45846_1.html</span>
                </li>
                <li>
                    <span class="class-name">造价员</span>
                    <span class="class-time">全能班</span>
                    <span class="class-price">5800</span>
                    <span class="class-src">http://m.koolearn.com/product/45846_1.html</span>
                </li>
                <li>
                    <span class="class-name">试验员</span>
                    <span class="class-time">74</span>
                    <span class="class-price">600</span>
                    <span class="class-src">http://m.koolearn.com/product/45849_1.html</span>
                </li>
                <li>
                    <span class="class-name">劳务员</span>
                    <span class="class-time">91</span>
                    <span class="class-price">800</span>
                    <span class="class-src">http://m.koolearn.com/product/45831_1.html</span>
                </li>
                <li>
                    <span class="class-name">预算员</span>
                    <span class="class-time">取证班</span>
                    <span class="class-price">1000</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                                <li>
                    <span class="class-name">预算员</span>
                    <span class="class-time">实战班</span>
                    <span class="class-price">4200</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                                <li>
                    <span class="class-name">预算员</span>
                    <span class="class-time">精品班</span>
                    <span class="class-price">4800</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                                <li>
                    <span class="class-name">预算员</span>
                    <span class="class-time">综合班</span>
                    <span class="class-price">5200</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                                <li>
                    <span class="class-name">预算员</span>
                    <span class="class-time">全能班</span>
                    <span class="class-price">5800</span>
                    <span class="class-src">http://m.koolearn.com/product/45835_1.html</span>
                </li>
                <li>
                    <span class="class-name">测量员</span>
                    <span class="class-time">取证班</span>
                    <span class="class-price">1000</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                                <li>
                    <span class="class-name">测量员</span>
                    <span class="class-time">实战班</span>
                    <span class="class-price">3600</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                                <li>
                    <span class="class-name">测量员</span>
                    <span class="class-time">精品班</span>
                    <span class="class-price">4200</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                                <li>
                    <span class="class-name">测量员</span>
                    <span class="class-time">综合班</span>
                    <span class="class-price">4600</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                                <li>
                    <span class="class-name">测量员</span>
                    <span class="class-time">全能班</span>
                    <span class="class-price">5200</span>
                    <span class="class-src">http://m.koolearn.com/product/45855_1.html</span>
                </li>
                <li>
                    <span class="class-name">机械管理员</span>
                    <span class="class-time">80</span>
                    <span class="class-price">80</span>
                    <span class="class-src">http://m.koolearn.com/product/45858_1.html</span>
                </li>
            </ul>
        </div>
    </div>
    
    
	
</div><div class="head">
    <img src="http://leshucq.bj.bcebos.com/standard/standard_leshuslide1.jpg" />
</div>
<div class="content" id="app" v-cloak>
    <div class="content-nav">
        <ul class="tab fc">
            <li v-for="(data,index) in contentData" :class="tabIndex===index?'bg':''" @click="tabIndex=index">{{data.tabName}}</li>
        </ul>
        <div class="content-nav__lesson" v-for="(data,index) in contentData" :class="tabIndex===index?'bg':''">
            <ul class="testList fc">
                <li class="test" v-for="(list,i) in data.testList">
                    <a target="_blank" href="detailed/detailedPage.jsp">
                        <h4>{{list}}</h4>
                        <span>我要测评</span>
                    </a>

                </li>
            </ul>
            <h3>{{data.kbName}}<a :href="data.kbMore" target="_blank">更多</a></h3>
            <table v-for="kbIt in data.kbItem">
                <colgroup>
                    <col width="40%">
                    <col width="20%">
                    <col width="20%">
                    <col width="20%">
                </colgroup>
                <thead>
                    <th>{{kbIt.classTitle}}</th>
                    <th>课时</th>
                    <th>价格</th>
                    <th>购买</th>
                </thead>
                <tbody>
                    <tr v-for="classItem in kbIt.classItem">
                        <td><a target="_blank" :href="classItem.classSrc">{{classItem.className}}</a></td>
                        <td>{{classItem.classTime}}</td>
                        <td>￥{{classItem.classPrice}}</td>
                        <td><a class="buy" href="#">购买</a></td>
                        <!-- <td><a class="buy" :href="classItem.classSrc">购买</a></td> -->
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="m-footer">
    <h1>乐数在线</h1>
    <div class="tit2">
        <img src="h2.png" height="25" width="560">
    </div>
    <div class="main">
        <p class="intr">乐数珠心算成立于2014年（原名尔智尔慧珠心算）， 是重庆市方圆职业培训学校旗下幼儿培训品牌，乐数师资是由小学特级教师、全国教育系统劳动模范、全国十杰中小学中青年教师提名奖获得者、全国优秀珠心算教练师何克亮老师亲自授教和培训。乐数珠心算不仅传承了古老珠心算的优秀教学理念，而且拥有简单易懂属于自己独特的教学方法。实践证明，学过珠心算的儿童的计算速度比不学的儿童快3---5倍，被誉为开发儿童智力发展的“金钥匙”从而达到“一科学习，多科受益”的效果。乐数珠心算致力于幼儿珠心算的培训及幼儿综合素质的培养，致力于中华优秀非物质文化遗产的推广，向全世界展现中华文化魅力。</p>
        <div class="logo">
            <div class="lg">
                <a href="yy/yy.jsp"><img src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" height="81" width="158"></a>
            </div>
            <div class="lg">
                <img src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" height="68" width="140">
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="page.js"></script>
<script>
    seajs.use(['project/zt/2017/0420mnkcwap/js/page'], function(exports) {
        $(function() {
            exports.init();
        })
    })
</script>
<script src="header.js"></script>
<!-- <script type="text/javascript">
    (function(){
        seajs.use(['project/zt/2016/0530kyldywap/js/common/header/header'], function(init){
            init({
                //右侧登录菜单相关配置
                loginInfoUrl: '//i.koolearn.com/logininfo',
                login: {
                    loginUrl: "//login.koolearn1.com/sso/m/toLogin.do",  //登录地址
                    quitUrl: "//login.koolearn1.com/sso/logout.do",  //退出地址
                    userCenter: "javascript:;",  //个人中心
                    myCourse: "//study.koolearn.com?wp_f=w_menu",  //我的课程
                    myOrder: "//order.m.koolearn.com/m/user_order/index?wp_f=w_menu",  //我的订单
                    myDiscount: "//order.m.koolearn.com/m/coupon/index?wp_f=w_menu",  //我的优惠券
                    myLearnCard: "//order.m.koolearn.com/m/learning_card_account/index?wp_f=w_menu",  //我的学习卡账户
                    myCash: "//order.m.koolearn.com/m/cash_account/index?wp_f=w_menu"  //我的现金账户
                }
            });
        });
    })()
</script> -->
<script type="text/javascript" src="tongji_wap.js"></script>
<script type="text/javascript" src="GTM.js"></script>
</body>
</html>

<!-- 
	专题生成的时间:2017-07-11 12:07:10
	修改专题的人:sunzhengxin
	生成专题所用的模板:index_demo-2017-0420mnkcwap
-->