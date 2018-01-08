(function($){
   $.fn.czl_addressbox = function( options )
   {
	   this.each( function()  
	   {
		  var instance = $.data( this , 'czl_addressbox' );
		  
		  if( !instance )
		  {
			$.data( this, 'czl_addressbox' , $.createAddressBox( options , this ) );  
		  }
	   });//end of each
	   
	   return this;  //支持链式操作
   };
   
   $.createAddressBox = function( options , element ){
		//私有成员声明
		var addr_box = $( element );
		//相关的HTML组件
		var ab_showbar = addr_box.children( '.ab_showbar' ).eq(0);
		var ab_vauleinfo = ab_showbar.children( '.value_info' ).eq(0);
		var ab_btn = addr_box.children( '.ab_btn' ).eq(0);
		
		var ab_sheng_tab = addr_box.find( '.ab_bar li.sheng' ).eq(0);
		var ab_shi_tab = addr_box.find( '.ab_bar li.shi' ).eq(0);
		var ab_qu_tab = addr_box.find( '.ab_bar li.qu' ).eq(0);
		
		var ab_sheng_panel = addr_box.find( '.ab_panel dd.sheng' ).eq(0);
		var ab_shi_panel = addr_box.find( '.ab_panel dd.shi' ).eq(0);
		var ab_qu_panel = addr_box.find( '.ab_panel dd.qu' ).eq(0);
	
		var ab_shi_databox = addr_box.find( '.ab_panel dd.shi .ab_shi' ).eq(0);
		var ab_qu_databox = addr_box.find( '.ab_panel dd.qu .ab_qu' ).eq(0);
		
		//省份的选择控件
		var ab_sheng_item = addr_box.find( '.ab_sheng>li' );
		
		var addr_box_data = $.zl_addr_box_data;         //引用的全局变量
		
		//检测options中是否有省份、城市、区县等值传入
        var addr_obj = {
			sheng:'',
			shi:'',
			qu:'',
			sheng_id:0,
			shi_id:0,
			qu_id:0
		};

		//私有函数声明
		var _init = function( options ){
			//加载事件注册
			_loadEvents();
			
			//判断传入的options是否为空，不为空则默认是addr_obj对象
			if( options && typeof options.sheng_id !== 'undefined' ){				
				//是一个合理的options对象
				_init_addr_obj( options );
			}
			
		    //初始化控件中data的值
		    addr_box.data( 'addr_value' , '' ); 
			return ;
		};
		
		//依据a_obj的值初始化控件的状态
		var _init_addr_obj = function( a_obj ){
				addr_obj.sheng_id = a_obj.sheng_id ;
				addr_obj.shi_id = a_obj.shi_id ;
				addr_obj.qu_id = a_obj.qu_id ;
				//就取得传入的id的值，然后再取得名称
				//更新'城市列表','区县列表'的值
				//设置addr_obj的省，市，区县的名称，并更新界面
				addr_obj.sheng = addr_box_data['0'][addr_obj.sheng_id];
				addr_obj.shi = addr_box_data['0_'+addr_obj.sheng_id][addr_obj.shi_id];
				addr_obj.qu = addr_box_data['0_'+addr_obj.sheng_id+'_'+addr_obj.shi_id][addr_obj.qu_id];
				
				//更新界面
				//触发选中了id为sheng_id的事件
				//添加城市的项到shi_panel当中
				ab_shi_databox.html('');
				var shi_array = addr_box_data['0_'+addr_obj.sheng_id];
				for( var i=0 ; i<shi_array.length ; i+=1 ){
					ab_shi_databox.append( '<li>'+shi_array[i]+'</li>' );
				}//end for, 遍历所有的市
				
				//触发选中了id为shi_id的城市的事件
				ab_qu_databox.html('');
				var qu_array = addr_box_data['0_'+addr_obj.sheng_id + '_' + addr_obj.shi_id];
				for( var i=0 ; i<qu_array.length ; i+=1 ){
					ab_qu_databox.append( '<li>'+qu_array[i]+'</li>' );
				}//end for, 遍历所有的区县
				
				//标记当前省、市、区县的选中状态
				//省
				for( var i=0 ; i<ab_sheng_item.length ; i+=1 ){
					if( ab_sheng_item.eq(i).html() === addr_obj.sheng ){
						ab_sheng_item.eq(i).addClass( 'current' );
						break ;
					}
				}
				//市
				ab_shi_databox.children().eq(addr_obj.shi_id).addClass( 'current' );
				//区县
				ab_qu_databox.children().eq(addr_obj.qu_id).addClass( 'current' );
				
				//默认显示区县的选项卡
				ab_qu_tab.addClass('current').siblings().removeClass( 'current' );
				ab_qu_panel.addClass('current').siblings().removeClass( 'current' );
				
				//再更新value中的值
				_updateAddrValue( );
				
				return ;
		}
		
		//更新地址栏中的值
		var _updateAddrValue = function(){
			if( addr_obj.sheng === '' ){
				ab_showbar.addClass( 'tip' );
			}
			else{
				//先清空原有的内容
				ab_vauleinfo.html( '' );
				ab_vauleinfo.append( '<span name="addr_c" id="addr_c">'+addr_obj.sheng+'</span>' );
				if( addr_obj.shi !== '' &&  addr_obj.shi !== addr_obj.sheng){
					ab_vauleinfo.append( '<span class="sep">/</span><span name="addr_d" id="addr_d">'+addr_obj.shi+'</span>' );
					if( addr_obj.qu !== '' ){
						ab_vauleinfo.append( '<span class="sep">/</span><span name="addr_s" id="addr_s">'+addr_obj.qu+'</span>' );
					}
				}
				else if( addr_obj.shi !== '' &&  addr_obj.shi === addr_obj.sheng){
					if( addr_obj.qu !== '' ){
						ab_vauleinfo.append( '<span class="sep">/</span><span>'+addr_obj.qu+'</span>' );
					}
				}
				//去除提示状态
				ab_showbar.removeClass( 'tip' );
				
				//同步将值附到data属性中
				addr_box.data( 'addr_value' , addr_obj.sheng+'_'+addr_obj.shi+'_'+addr_obj.qu ); 
			}
			return ;
		};
		
		//选择序号为sheng_id的省份之后的响应事件
		var _selectShengId = function( sheng_index ){
			if( typeof sheng_index === 'number' ){
				var sheng_name = addr_box_data['0'][sheng_index];
				var shi_array_id = '0_' +  sheng_index;
				var shi_array = addr_box_data[shi_array_id];
				
				//添加城市的项到shi_panel当中
				ab_shi_databox.html('');
				for( var i=0 ; i<shi_array.length ; i+=1 ){
					ab_shi_databox.append( '<li>'+shi_array[i]+'</li>' );
				}//end for, 遍历所有的市
				
				//对这些城市选项添加响应函数
				ab_shi_databox.children().on( 'click' , function(){
					if( $(this).hasClass('current') ){
						return ;
					}
					//获得省份对应的id的值
					var shi_id = $(this).index();
					//响应选中城市之后的响应函数
					_selectShiId( shi_id );
					//标记当前选中的"城市"
					$(this).addClass('current').siblings().removeClass( 'current' );
					return ;
				});
				
				//显示"城市"页签的内容
				//判断是否是'北京'、'上海'、天津、重庆等直辖市
				var shi_list_id = '0_'+sheng_index;
				//这里处理需要跳过'市'这一级别的处理
				if( addr_box_data[shi_list_id].length === 1 ){
					//更新地址的值
					addr_obj.sheng = sheng_name;
					addr_obj.shi = '' + addr_box_data['0_'+sheng_index+'_0'] ;
					addr_obj.qu = '' ;
					addr_obj.sheng_id = ''+sheng_index;
					addr_obj.shi_id = '0' ;
					addr_obj.qu_id = '' ;
								
					//更新地址栏中的值
					_updateAddrValue( );
					//触发选中了区的选项卡
					_selectShiId( 0 );
				}
				else{
					ab_shi_tab.addClass('current').siblings().removeClass( 'current' );
					ab_shi_panel.addClass('current').siblings().removeClass( 'current' );

					//更新地址的值
					addr_obj.sheng = sheng_name;
					addr_obj.shi = '' ;
					addr_obj.qu = '' ;
					addr_obj.sheng_id = ''+sheng_index;
					addr_obj.shi_id = '' ;
					addr_obj.qu_id = '' ;
								
					//更新地址栏中的值
					_updateAddrValue( );
				}
			}
			return ;
		};
		
		//选择序号为shi_index的城市之后的响应事件
		var _selectShiId = function( shi_index ){
			if( typeof shi_index === 'number' ){
				var shi_id = '0'+'_'+addr_obj.sheng_id  ;
				var shi_name = addr_box_data[shi_id][shi_index];
				var qu_array_id = '0_' +  addr_obj.sheng_id + '_'+shi_index;
				var qu_array = addr_box_data[qu_array_id];
				
				//添加区县的项到qu_panel当中
				ab_qu_databox.html('');
				for( var i=0 ; i<qu_array.length ; i+=1 ){
					ab_qu_databox.append( '<li>'+qu_array[i]+'</li>' );
				}//end for, 遍历所有的区县
				
				//对这些城市选项添加响应函数
				ab_qu_databox.children().on( 'click' , function(){
					if( $(this).hasClass('current') ){
						return ;
					}
					//获得省份对应的id的值
					var qu_id = $(this).index();
					//响应选中城市之后的响应函数
					_selectQuId( qu_id );
					$(this).addClass('current').siblings().removeClass( 'current' );
					return ;
				});
				
				//显示"区县"页签的内容
				ab_qu_tab.addClass('current').siblings().removeClass( 'current' );
				ab_qu_panel.addClass('current').siblings().removeClass( 'current' );
				
				//更新地址的值
				addr_obj.shi = shi_name ;
				addr_obj.qu = '' ;
				addr_obj.shi_id = ''+shi_index;
				addr_obj.qu_id = '' ;
				
				//更新地址栏中的值
				_updateAddrValue( );
			}
			return ;
		};
		//选择序号为qu_index的区县之后的响应事件
		var _selectQuId = function( qu_index ){
			if( typeof qu_index === 'number' ){
				var qu_id = '0'+'_'+addr_obj.sheng_id + '_' + addr_obj.shi_id  ;
				var qu_name = addr_box_data[qu_id][qu_index];
				
				//更新地址的值
				addr_obj.qu = qu_name ;
				addr_obj.qu_id = '' +qu_index ;

				//更新地址栏中的值
				_updateAddrValue( );
				
				//隐藏选择面板
				addr_box.toggleClass( 'selected' );
			}
			return ;
		};
		
		//根据省份的名称，选择对应的id
		var getShengIDFromName = function( sheng_name ){
			var sheng_list = addr_box_data['0'];
			var sheng_id = 0 ;
			for( sheng_id = 0 ; sheng_id<sheng_list.length ; sheng_id+=1 ){
				if( sheng_list[sheng_id] === sheng_name ){
					break ;
				}
			}
			return sheng_id ;
		}
		
		//注册事件
		var _loadEvents = function(){
			ab_showbar.on( 'click' , function(){
				addr_box.toggleClass( 'selected' );
				return ;
			});
			ab_btn.on( 'click' , function(){
				addr_box.toggleClass( 'selected' );
				return ;
			});
			//单击省份的选项
			ab_sheng_item.on( 'click' , function(){
				//如果单击已经选中的省份，则不响应该事件
				if( $(this).hasClass('current') ){
					return ;
				}
				//获得省份对应的id的值
				var sheng_name = $(this).html();
				var addr_id = getShengIDFromName( sheng_name );
				
				//初始化"城市"页签的内容，并注册事件响应函数
				_selectShengId( addr_id );
				
				//标记当前选中的"省"
				ab_sheng_item.removeClass('current');
				$(this).addClass('current');
				
				return ;				
			});
			//单击'省份的页签'
			ab_sheng_tab.on( 'click' , function(){
				if( $(this).hasClass('current') ){
					return ;
				}
				//显示省份的页签和面板
				ab_sheng_tab.addClass('current').siblings().removeClass( 'current' );
				ab_sheng_panel.addClass('current').siblings().removeClass( 'current' );
				return ;
			});
			//单击'城市的页签'
			ab_shi_tab.on( 'click' , function(){
				if( $(this).hasClass('current') ){
					return ;
				}
				//显示省份的页签和面板
				//确定已经选择了省份
				if( addr_obj.sheng !== '' ){
					ab_shi_tab.addClass('current').siblings().removeClass( 'current' );
					ab_shi_panel.addClass('current').siblings().removeClass( 'current' );
				}
				return ;
			});
			//单击'区县的页签'
			ab_qu_tab.on( 'click' , function(){
				if( $(this).hasClass('current') ){
					return ;
				}
				//显示省份的页签和面板
				//确定已经选择了省份和城市
				if( addr_obj.sheng !== '' && addr_obj.shi !== '' ){
					ab_qu_tab.addClass('current').siblings().removeClass( 'current' );
					ab_qu_panel.addClass('current').siblings().removeClass( 'current' );
				}
				return ;
			});
		
			//单击'市'下面的选项的响应事件
			ab_shi_databox.on( 'click' , function( event ){
				//阻止事件冒泡
				event.stopPropagation();
				var $target = $( event.target );
				if( $target.attr( 'tagName' ) === 'li' ){
					var shi_item = $target ;
					//如果当前的'市'选项就是选中的选项，则不响应事件，直接返回
					if( shi_item.hasClass('current') ){
						return ;
					}
					//获得省份对应的id的值
					var shi_id = shi_item.index();
					//响应选中城市之后的响应函数
					_selectShiId( shi_id );
					//标记当前选中的"城市"
					shi_item.addClass('current').siblings().removeClass( 'current' );
				}//如果是子元素li上触发的事件
				return ;
			});
			
			//单击'区'下面的选项的响应事件
			ab_qu_databox.on( 'click' , function( event ){
				//阻止事件冒泡
				event.stopPropagation();
				var $target = $( event.target );
				if( $target.attr( 'tagName' ) === 'li' ){
					var qu_item = $target ;
					if( qu_item.hasClass('current') ){
						return ;
					}
					//获得省份对应的id的值
					var qu_id = qu_item.index();
					//响应选中城市之后的响应函数
					_selectQuId( qu_id );
					qu_item.addClass('current').siblings().removeClass( 'current' );
					return ;
				}
			});
		
		};

		//执行私有函数
		_init( options );

		//创建对象
		var that = {
			get_addr_obj:function(){
				return addr_obj;
			},
			set_addr_obj:function( a_obj ){
				_init_addr_obj( a_obj );
				return ;
			}
		};
		
		
		//返回对象
		return that ;
   }
   //重庆的地址信息
   $.zl_addr_box_data = (function( ){
	  var that = {
'0':['重庆市'],
'0_0':['渝中区','大渡口区','江北区','沙坪坝区','九龙坡区','南岸区','北碚区','渝北区','巴南区','万州区','涪陵区','綦江区','大足区','黔江区','长寿区','江津区','合川区','永川区','南川区','璧山区','铜梁区','潼南区','荣昌区','梁平县','城口县','丰都县','垫江县','武隆县','忠县','开州区','云阳县','奉节县','巫山县','巫溪县','石柱县','秀山县','酉阳县','彭水县'],
//渝中区
'0_0_0':['七星岗街道','解放碑街道','两路口街道','上清寺街','道菜园坝街道','南纪门街道','望龙门街道','朝天门街道','大溪沟街道','大坪街道','化龙桥街道','石油路街道'],
//大渡口区
'0_0_1':['新山村街道','跃进村街道','九宫庙街道','茄子溪街道','春晖路街道','八桥镇','建胜镇','跳磴镇'],
//江北区
'0_0_2':['华新街街道','江北城街道','石马河街道','大石坝街道','寸滩街道','观音桥街道','五里店街道','郭家沱街道','铁山坪街道','鱼嘴镇','复盛镇','五宝镇'],
//沙坪坝区
'0_0_3':['小龙坎街道','沙坪坝街道','渝碚路街道','磁器口街道','童家桥街道','石井坡街道','双碑街道','井口街道','歌乐山街道','山洞街道','新桥街道','天星桥街道','土湾街道','覃家岗街道','陈家桥街道','虎溪街道','西永街道','联芳街道','井口镇','歌乐山镇','青木关镇','凤凰镇','回龙坝镇','曾家镇','土主镇','中梁镇'],
//九龙坡区
'0_0_4':['杨家坪街道','黄桷坪街道','谢家湾街道','石坪桥街道','石桥铺街道','中梁山街道','渝州路街道','九龙镇','华岩镇','含谷镇','金凤镇','白市驿镇','走马镇','石板镇','巴福镇','陶家镇','西彭镇','铜罐驿镇'],
//南岸区
'0_0_5':['铜元局街道','花园路街道','南坪街道','海棠溪街道','龙门浩街道','弹子石街道','南山街道','天文街道','南坪镇','涂山镇','鸡冠石镇','峡口镇','长生桥镇','迎龙镇','广阳镇'],
//北碚区
'0_0_6':['天生街道','朝阳街道','北温泉街道','东阳街道','龙凤桥街道','歇马镇','澄江镇','蔡家岗镇','童家溪镇','天府镇','施家梁镇','水土镇','静观镇','柳荫镇','复兴镇','三圣镇','金刀峡镇'],
//渝北区
'0_0_7':['双龙湖街道','回兴街道','鸳鸯街道','翠云街道','人和街道','天宫殿街道','龙溪街道','龙山街道','龙塔街道','大竹林街道','悦来街道','两路街道','双凤桥街道','王家街道','礼嘉街道','金山街道','康美街道','宝圣湖街道','仙桃街道','玉峰山镇','龙兴镇','统景镇','大湾镇','兴隆镇','木耳镇','茨竹镇','古路镇','石船镇','大盛镇','洛碛镇'],
//巴南区
'0_0_8':['龙洲湾街道','鱼洞街道','花溪街道','李家沱街道','南泉街道','一品街道','南彭街道','惠民街道','界石镇','安澜镇','跳石镇','木洞镇','双河口镇','麻柳嘴镇','丰盛镇','二圣镇','东泉镇','姜家镇','天星寺镇','接龙镇','石滩镇','石龙镇'],
//万州区
'0_0_9':['高笋塘街道','太白街道','牌楼街道','双河口街道','龙都街道','周家坝街道','沙河街道','钟鼓楼街道','百安坝街道','五桥街道','陈家坝街道','小周镇','大周镇','新乡镇','孙家镇','高峰镇','龙沙镇','响水镇','武陵镇','瀼渡镇','甘宁镇','天城镇','熊家镇','高梁镇','李河镇','分水镇','余家镇','后山镇','弹子镇','长岭镇','新田镇','白羊镇','龙驹镇','走马镇','罗田镇','太龙镇','长滩镇','太安镇','白土镇','郭村镇','柱山乡','铁峰乡','溪口乡','长坪乡','燕山乡','梨树乡','普子乡','地宝土家族乡','恒合土家族乡','黄柏乡','九池乡','茨竹乡'],
//涪陵区
'0_0_10':['敦仁街道','崇义街道','荔枝街道','江北街道','江东街道','李渡街道','龙桥街道','白涛街道','南沱镇','青羊镇','百胜镇','珍溪镇','清溪镇','焦石镇','马武镇','龙潭镇','蔺市镇','新妙镇','石沱镇','义和镇','罗云乡','大木乡','武陵山乡','大顺乡','增福乡','同乐乡'],
//綦江区
'0_0_11':['古南街道','文龙街道','三江街道','万盛街道','东林街道','万东镇','南桐镇','青年镇','关坝镇','丛林镇','石林镇','金桥镇','黑山镇','石角镇','东溪镇','赶水镇','打通镇','石壕镇','永新镇','三角镇','隆盛镇','郭扶镇','篆塘镇','丁山镇','安稳镇','扶欢镇','永城镇','新盛镇','中峰镇','横山镇'],
//大足区
'0_0_12':['龙岗街道','棠香街道','龙滩子街道','龙水镇','智凤街道','宝顶镇','中敖镇','三驱镇','宝兴镇','玉龙镇','石马镇','拾万镇','回龙镇','金山镇','万古镇','国梁镇','雍溪镇','珠溪镇','龙石镇','邮亭镇','铁山镇','高升镇','季家镇','古龙镇','高坪镇','双路街道','通桥街道'],
//黔江区
'0_0_13':['城东街道','城南街道','城西街道','正阳街道','舟白街道','冯家街道','阿蓬江镇','石会镇','黑溪镇','黄溪镇','黎水镇','金溪镇','马喇镇','濯水镇','石家镇','鹅池镇','小南海镇','邻鄂镇','中塘乡','蓬东乡','沙坝乡','白石乡','杉岭乡','太极乡','水田乡','白土乡','金洞乡','五里乡','水市乡','新华乡'],
//长寿区
'0_0_14':['凤城街道','晏家街道','江南街道','渡舟街道','邻封镇','但渡镇','云集镇','长寿湖镇','双龙镇','龙河镇','石堰镇','云台镇','海棠镇','葛兰镇','新市街道','八颗街道','洪湖镇','万顺镇'],
//江津区
'0_0_15':['几江街道','德感街道','双福街道','鼎山街道','油溪镇','吴滩镇','石门镇','朱杨镇','石蟆镇','永兴镇','塘河镇','白沙镇','龙华镇','李市镇','慈云镇','蔡家镇','中山镇','嘉平镇','柏林镇','先锋镇','珞璜镇','贾嗣镇','夏坝镇','西湖镇','杜市镇','广兴镇','四面山镇','支坪镇'],
//合川区
'0_0_16':['合阳城街道','钓鱼城街道','南津街街道','盐井街道','草街街道','云门街道','大石街道','沙鱼镇','官渡镇','涞滩镇','肖家镇','古楼镇','三庙镇','二郎镇','龙凤镇','隆兴镇','铜溪镇','双凤镇','狮滩镇','清平镇','土场镇','小沔镇','三汇镇','香龙镇','钱塘镇','龙市镇','燕窝镇','太和镇','渭沱镇','双槐镇'],
//永川区
'0_0_17':['中山路街道','胜利路街道','南大街街道','茶山竹海街道','大安街道','陈食街道','卫星湖街道','青峰镇','金龙镇','临江镇','何埂镇','松溉镇','仙龙镇','吉安镇','五间镇','来苏镇','宝峰镇','双石镇','红炉镇','永荣镇','三教镇','板桥镇','朱沱镇'],
//南川区
'0_0_18':['东城街道','南城街道','西城街道','三泉镇','南平镇','神童镇','鸣玉镇','大观镇','兴隆镇','太平场镇','白沙镇','水江镇','石墙镇','金山镇','头渡镇','大有镇','合溪镇','黎香湖镇','山王坪镇','石莲乡','木凉镇','河图乡','乾丰乡','骑龙乡','中桥乡','楠竹山','镇德隆乡','庆元乡','古花乡','峰岩乡','民主乡','冷水关乡','石溪镇','福寿乡'],
//璧山区
'0_0_19':['璧城街道','璧泉街道','青杠街道','来凤街道','丁家街道','大路街道','八塘镇','七塘镇','河边镇','福禄镇','大兴镇','正兴镇','广普镇','三合镇','健龙镇'],
//铜梁区
'0_0_20':['巴川街道','东城街道','南城街道','土桥镇','二坪镇','水口镇','安居镇','白羊镇','平滩镇','石鱼镇','福果镇','维新镇','高楼镇','大庙镇','围龙镇','华兴镇','永嘉镇','安溪镇','西河镇','太平镇','旧县街道','虎峰镇','少云镇','蒲吕镇','侣俸镇','小林镇','双山镇','庆隆镇'],
//潼南区
'0_0_21':['桂林街道','梓潼街道','上和镇','龙形镇','古溪镇','宝龙镇','玉溪镇','米心镇','群力镇','双江镇','花岩镇','柏梓镇','崇龛镇','塘坝镇','新胜镇','太安镇','小渡镇','卧佛镇','五桂镇','田家镇','别口镇','寿桥镇'],
//荣昌区
'0_0_22':['昌元街道','昌洲街道','广顺街道','双河街道','安富街道','峰高街道','直升镇','万灵镇','清江镇','仁义镇','河包镇','古昌镇','吴家镇','观胜镇','铜鼓镇','清流镇','盘龙镇','远觉镇','清升镇','荣隆镇','龙集镇'],
//梁平县
'0_0_23':['梁山街道','双桂街道','仁贤镇','礼让镇','云龙镇','屏锦镇','袁驿镇','新盛镇','福禄镇','金带镇','聚奎镇','明达镇','荫平镇','和林镇','回龙镇','碧山镇','虎城镇','七星镇','龙门镇','文化镇','合兴镇','石安镇','柏家镇','大观镇','竹山镇','蟠龙镇','安胜乡','铁门乡','龙胜乡','复平乡','紫照乡','城北乡','曲水乡','梁平县农场','双桂工业园区'],
//城口县
'0_0_24':['葛城街道','复兴街道','巴山镇','坪坝镇','庙坝镇','明通镇','修齐镇','高观镇','高燕镇','龙田乡','北屏乡','高楠乡','左岚乡','沿河乡','双河乡','蓼子乡','鸡鸣乡','咸宜乡','周溪乡','明中乡','治平乡','岚天乡','厚坪乡','河鱼乡','东安乡'],
//丰都县
'0_0_25':['三合街道','名山街道','虎威镇','社坛镇','三元镇','许明寺镇','董家镇','树人镇','十直镇','高家镇','兴义镇','双路镇','江池镇','龙河镇','武平镇','包鸾镇','湛普镇','南天湖镇','保合镇','兴龙镇','仁沙镇','龙孔镇','暨龙镇','双龙镇','仙女湖镇','青龙乡','太平坝乡','都督乡','栗子乡','三建乡'],
//垫江县
'0_0_26':['桂阳街道','桂溪街道','桂溪镇','新民镇','沙坪镇','周嘉镇','普顺镇','永安镇','高安镇','高峰镇','五洞镇','澄溪镇','太平镇','鹤游镇','坪山镇','砚台镇','曹回镇','杠家镇','包家镇','白家镇','永平镇','三溪镇','裴兴镇','长龙乡','沙河乡','大石乡','黄沙乡'],
//武隆县
'0_0_27':['巷口镇','火炉镇','白马镇','鸭江镇','长坝镇','江口镇','平桥镇','羊角镇','仙女山镇','桐梓镇','土坎镇','和顺镇','凤来乡','庙垭乡','石桥乡','双河乡','黄莺乡','沧沟乡','文复乡','土地乡','白云乡','后坪乡','浩口乡','接龙乡','赵家乡','铁矿乡'],
//忠县
'0_0_28':['忠州街道','白公街道','忠州镇','新生镇','任家镇','乌杨镇','洋渡镇','东溪镇','复兴镇','石宝镇','汝溪镇','野鹤镇','官坝镇','石黄镇','马灌镇','金鸡镇','新立镇','双桂镇','拔山镇','花桥镇','永丰镇','三汇镇','白石镇','黄金镇','善广乡','石子乡','磨子乡','涂井乡','金声乡','兴峰乡'],
//开州区
'0_0_29':['镇东街道','丰乐街道','白鹤街道','汉丰街道','文峰街道','云枫街道','赵家街道','郭家镇','温泉镇','铁桥镇','南雅镇','和谦镇','镇安镇','竹溪镇','渠口镇','厚坝镇','高桥镇','义和镇','大进镇','长沙镇','临江镇','敦好镇','中和镇','岳溪镇','南门镇','河堰镇','九龙山镇','白桥镇','天和镇','金峰镇','谭家镇','巫山镇','大德镇','白泉乡','关面乡','满月乡','五通乡','麻柳乡','紫水乡','三汇口乡'],
//云阳县
'0_0_30':['双江街道','青龙街道','人和街道','盘龙街道','龙角镇','故陵镇','红狮镇','路阳镇','农坝镇','渠马镇','黄石镇','巴阳镇','沙市镇','鱼泉镇','凤鸣镇','宝坪镇','南溪镇','双土镇','桑坪镇','江口镇','高阳镇','平安镇','云阳镇','云安镇','栖霞镇','双龙镇','泥溪镇','票草镇','养鹿镇','水口镇','堰坪镇','龙洞镇','后叶镇','外郎乡','耀灵乡','新津乡','普安乡','洞鹿乡','石门乡','大阳乡','上坝乡','清水乡'],
//奉节县
'0_0_31':['永安镇','白帝镇','草堂镇','汾河镇','康乐镇','大树镇','竹园镇','公平镇','朱衣镇','甲高镇','羊市镇','吐祥镇','兴隆镇','青龙镇','新民镇','永乐镇','安坪镇','五马镇','青莲镇','岩湾乡','平安乡','红土乡','石岗乡','康坪乡','太和乡','鹤峰乡','冯坪乡','长安乡','龙桥乡','云雾乡','白帝城风景区'],
//巫山县
'0_0_32':['高唐街道','龙门街道','庙宇镇','大昌镇','福田镇','龙溪镇','双龙镇','官阳镇','骡坪镇','抱龙镇','官渡镇','铜鼓镇','巫峡镇','红椿乡','两坪乡','曲尺乡','建坪乡','大溪乡','金坪乡','平河乡','当阳乡','竹贤乡','三溪乡','培石乡','笃坪乡','邓家乡'],
//巫溪县
'0_0_33':['宁河街道','柏杨街道','城厢镇','凤凰镇','宁厂镇','上磺镇','古路镇','文峰镇','徐家镇','白鹿镇','尖山镇','下堡镇','峰灵镇','塘坊镇','朝阳镇','田坝镇','通城镇','胜利乡','菱角乡','大河乡','天星乡','长桂乡','蒲莲乡','鱼鳞乡','乌龙乡','中岗乡','花台乡','兰英乡','双阳乡','中梁乡','天元乡','土城乡','红池坝经济开发区'],
//石柱县
'0_0_34':['南宾镇','西沱镇','下路镇','悦崃镇','临溪镇','黄水镇','马武镇','沙子镇','王场镇','沿溪镇','龙沙镇','鱼池镇','三河镇','大歇镇','桥头镇','万朝镇','冷水镇','黄鹤镇','黎场乡','三星乡','六塘乡','三益乡','王家乡','河嘴乡','石家乡','枫木乡','中益乡','洗新乡','黄鹤乡','龙潭乡','新乐乡','金铃乡','金竹乡'],
//秀山县
'0_0_35':['中和街道','乌杨街道','平凯街道','清溪场镇','隘口镇','溶溪镇','官庄镇','龙池镇','石堤镇','峨溶镇','洪安镇','雅江镇','石耶镇','梅江镇','兰桥镇','膏田镇','溪口镇','妙泉镇','宋农镇','里仁镇','钟灵镇','孝溪乡','海洋乡','大溪乡','涌洞乡','中平乡','岑溪乡'],
//酉阳县
'0_0_36':['桃花源街道','钟多街道','桃花源镇','龙潭镇','麻旺镇','酉酬镇','大溪镇','兴隆镇','黑水镇','丁市镇','龚滩镇','李溪镇','泔溪镇','酉水河镇','苍岭镇','小河镇','板溪镇','涂市乡','铜鼓乡','可大乡','偏柏乡','五福乡','木叶乡','毛坝乡','花田乡','后坪乡','天馆乡','宜居乡','万木乡','两罾乡','板桥乡','官清乡','南腰界乡','车田乡','腴地乡','清泉乡','庙溪乡','浪坪乡','双泉乡','楠木乡'],
//彭水县
'0_0_37':['汉葭街道','绍庆街道','靛水街道','保家镇','郁山镇','高谷镇','桑柘镇','鹿角镇','黄家镇','普子镇','龙射镇','连湖镇','万足镇','平安镇','长生镇','新田镇','鞍子镇','岩东乡','鹿鸣乡','棣棠乡','太原镇','三义乡','联合乡','石柳乡','龙溪镇','走马乡','芦塘乡','乔梓乡','梅子垭镇','诸佛乡','大同镇','桐楼乡','善感乡','双龙乡','石盘乡','大垭乡','润溪乡','朗溪乡','龙塘乡']
	  };	  
	  return that ;
   })();
   
}(jQuery));
