var info=angular.module('infoApp', ['ngResource']);

info.directive('xxxxx',function(){
	return{
		restrict : 'E',
		replace : true,
		transclude : true,
		template : '<table class="table table-striped" style="border: 1px solid;border-color:#ddd;">' +
						'<thead>'+
							'<tr>'+
								'<td colspan="4" style="color:white; background-color: #6d6d6d;">'+
									'<h4 style="margin-top: 0px;margin-bottom: 0px;">Resume</h4>'+
								'</td>'+
							'</tr>'+
						'</thead>'+
						'<tbody>'+
							'<tr>'+
								'<td>name</td>'+
								'<td>{{person.details.name}}</td>'+
								'<td>gender</td>'+
								'<td>{{person.details.gender}}</td>'+
							'</tr>'+
							'<tr>'+
								'<td>birthday</td>'+
								'<td>{{person.details.birthday}}</td>'+
								'<td>address</td>'+
								'<td>{{person.details.address}}</td>'+
							'</tr>'+
							'<tr>'+
								'<td>telephone</td>'+
								'<td>{{person.details.telephone}}</td>'+
								'<td>email</td>'+
								'<td>{{person.details.email}}</td>'+
							'</tr>'+
							'<tr>'+
								'<td>education</td>'+
								'<td>{{person.details.education}}</td>'+
								'<td>language</td>'+
								'<td>{{person.details.language}}</td>'+
							'</tr>'+
						'</tbody>'+
					'</table>'
	};
});
	
info.controller('detailsCtrl',['$scope','$resource',function($scope,$resource){

	$scope.detailsinfo ={"pageNum":1,
			"totalNum":200,
			"totalPage":12,
			"appointmentList":[
              {"show":false,"name":"王二小","tel":"18888888888","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:18","description":"未备注"},
              {"show":false,"name":"王三小","tel":"18888888889","age":"四周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王四小","tel":"18888888880","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王五小","tel":"18888888881","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王六小","tel":"18888888882","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区黄泥磅","date":"2017/12/18 9:15:19","description":"未备注"},
              {"show":false,"name":"王七小","tel":"18888888883","age":"五周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王八小","tel":"18888888884","age":"三周岁","sex":"男孩","school":"杨家坪校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:14:15","description":"未备注"},
              {"show":false,"name":"王九小","tel":"18888888885","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888886","age":"八周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888887","age":"三周岁","sex":"男孩","school":"青少年宫","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888808","age":"三周岁","sex":"女孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:17:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888818","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888828","age":"六周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888838","age":"三周岁","sex":"男孩","school":"杨家坪校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888848","age":"七周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:13:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888858","age":"三周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888868","age":"九周岁","sex":"男孩","school":"李家沱校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:12:15","description":"未备注"},
              {"show":false,"name":"王二小","tel":"18888888878","age":"三周岁","sex":"男孩","school":"江北校区","subject":"YY拼音","addr":"江北区观音桥","date":"2017/12/18 9:15:15","description":"未备注"}
            ]};	
	

 	
	var detailsInfo= $resource('/details/:page',{page:'@page'});
	
	detailsInfo.get({page:1},function(detailsInfo){
		$scope.detailsinfo=detailsInfo;
	});
	

	$scope.showDetail=function(detail){
		detail.show = !detail.show;
	};

	$scope.showNextPage=function(){
		var totalPage =$scope.detailsinfo.totalPage;
		var pageNum = $scope.detailsinfo.pageNum;
		if(pageNum<totalPage){
			detailsInfo.get({page:pageNum+1},function(detailsInfo){
				$scope.detailsinfo=detailsInfo;
			});
		}
	};
	
	$scope.showPreviousPage=function(){
		var pageNum = $scope.detailsinfo.pageNum;
		if(pageNum>1){
			detailsInfo.get({page:pageNum-1},function(detailsInfo){
				$scope.detailsinfo=detailsInfo;
			});
		}
	};

}]);
