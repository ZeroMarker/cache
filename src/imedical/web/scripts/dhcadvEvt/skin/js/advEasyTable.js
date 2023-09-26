//qqa
//2018-04-25
//用于安贞医院统计界面卡顿设计，一个简单的table
;(function ($) {
	var _opDomSevice = {
		preCreateDom:function(_this,_params){ 
			
		},
		createDom:function(_this,_params){ 
			_this.wrap("<div calss='easytable-panel'></div>");
			_this.parent().append("<div class='easytable-header' style='overflow:hidden'></div>");
			_this.parent().append("<div class='easytable-body' style='overflow:auto'></div>");
			_this.parent().append("<div class='easytable-footer'></div>");
			opDomDao.setPanelWidth(_this);
			opDomDao.setBodyWidth(_this,_this.parent().find(".easytable-body"));
			opDomDao.setBodyMethod(_this,_this.parent().find(".easytable-body"));
			_this.hide();      
		},
		preDispose:function(_this,_params){
			if(_params.rownumbers){   //添加序号显示
				var cnumber = {"field":"numbers","title":"序号","align":"center"};
				_params.columns.unshift(cnumber);
			}
		},
		proCreateDom:function(_this,_params){   
			opDomDao.opTdAndThWidth(_this,_params); //处理header与body之间的宽度一致
			opDomDao.opThPaddingRight(_this,_params); //处理header与body之间的宽度一致
		},
		initTile:function(_this,_columns){
			var _tDom = $("<tr class='easytable-header-row'></tr>");
			for(var i=0;i<_columns.length;i++){
				opDomDao.addItmTitle(_tDom,_columns[i]);
			}
			$(_this).parent().find(".easytable-header").append(_tDom);
		},
		initData:function(_this,_params){
			var _thisParef = $(_this).parent();
			var _waitDomCss="";
			var _waitDom="";
			var _waitTip = "正在加载......";
			_waitDomCss=_waitDomCss+"position:absolute;";
			_waitDomCss=_waitDomCss+"left:"+parseInt(_thisParef.width()/2)+";";
			_waitDomCss=_waitDomCss+"top:"+parseInt(_thisParef.height()/3)+";";
			_waitDomCss=_waitDomCss+"border:1px solid blue;";
			_waitDomCss=_waitDomCss+"font-size:15px;";
			_waitDomCss=_waitDomCss+"padding:5px;";
			
			_waitDom=_waitDom+"<div id='easyTableWaitDiv' style='"+_waitDomCss+"'>";
			_waitDom=_waitDom+_waitTip;
			_waitDom=_waitDom+"</div>";
		
			if(_params.url!==""){
				 $.ajax({
		             type: "post",
		             url: _params.url,
		             data: _params.queryParams,
		             dataType: "json",
		             beforeSend:function(){
			             if($("#easyTableWaitDiv").length==0) $(_this).parent().append(_waitDom);
			         },
		             success: function(data){
			            _params.data = data.rows;
		             	_opDomSevice.opData(_this,_params);
		             	if(_params.onLoadSuccess) _params.onLoadSuccess(data.rows);  //回调函数
		             	if(_params.onClickCell) opDomDao.onClickCell(_this,_params);
		             	if(_params.onClickCell) opDomDao.onClickRow(_this,_params);
		             	_opDomSevice.proCreateDom(_this,_params);                    //header and body width
		             	$(_this).parent().find("#easyTableWaitDiv").remove();
		             }
		         });
			}else{
				
				_opDomSevice.opData(_this,_params);
				if(_params.onLoadSuccess) _params.onLoadSuccess(_params.data);  //回调函数
				if(_params.onClickCell) opDomDao.onClickCell(_this,_params);
				if(_params.onClickCell) opDomDao.onClickRow(_this,_params);
				_opDomSevice.proCreateDom(_this,_params);
			}
			
			
		},
		opData:function(_this,_params){   //通过columns控制顺序，data决定数据
			var _rowDatas = _params.data;
			var _columns = _params.columns;
			
			
			for(var i=0;i<_rowDatas.length;i++){
				var _dDom = $("<tr datagrid-row-index='"+i+"' class='easytable-row'></tr>");
				if(_params.rownumbers){
					_rowDatas[i].numbers = i+1;
				}
				opDomDao.addItmData(_dDom,_rowDatas[i],_params);
				$(_this).parent().find(".easytable-body").append(_dDom);
			}
			
		}
	}
	
	var opDomDao = {
		addItmTitle:function(_tDom,_cItm){
			var _tItmHtml="";
			_tItmHtml = "<th class='easytable-th' field="+_cItm.field+">"
			_tItmHtml = _tItmHtml+_cItm.title;
			_tItmHtml = _tItmHtml+"</th>";
			_tItmHtml = $(_tItmHtml)
			_tDom.append(_tItmHtml);
			return _tItmHtml;
		},
		addItmData:function(_dDom,_data,_params){
			var _dItmHtml="",_cItm={},_columns = _params.columns;
			var tdStyle="",tdClass="";
			for(var i = 0; i<_columns.length;i++){
				tdStyle="",tdClass="easytable-td";
				_cItm = _columns[i];
				_dItmHtml="";
				
				
				var _fieldFormat = _cItm.formatter;
				if(typeof _fieldFormat=="function"){
					_data[_cItm.field]=	_fieldFormat(_data[_cItm.field],_data)
				}
				
				//本身class增加
				if(_data[_cItm.field]==undefined){
					
				}else if((0<_data[_cItm.field].length)&&(_data[_cItm.field].length<=15)){
					tdClass = tdClass+" easytable-td-d1"
				}else if((15<_data[_cItm.field].length)&&(_data[_cItm.field].length<=50)){
					tdClass = tdClass+" easytable-td-d2"
				}else if(50<_data[_cItm.field].length){
					tdClass = tdClass+" easytable-td-d3"
				}
				
				//本身样式增加
				if((_cItm.align)&&(_cItm.align!=undefined)){
					tdStyle = tdStyle+"text-align:"+_cItm.align+";"//align	
				}
				if(_params.nowrap){
					tdStyle = tdStyle+"white-space: nowrap;"//align	
				}
				
				_dItmHtml = "<td class='"+tdClass+"' "
				
				if(tdStyle!=""){
					_dItmHtml = _dItmHtml+"style='"+tdStyle+"'";		
				}
				_dItmHtml = _dItmHtml +"field="+_cItm.field+" ";  //text-align
				_dItmHtml = _dItmHtml+">"
				_dItmHtml = _dItmHtml+(_data[_cItm.field]===undefined?"":_data[_cItm.field]);
				_dItmHtml = _dItmHtml+"</td>";
				_dItmHtml = $(_dItmHtml)
				_dDom.append(_dItmHtml);	
			}
		},
		addItmNumber:function(_dDom,number){
			var _tItmHtml="";
			_dItmHtml = "<td class='easyTable-th' field='nunmbers'>"
			_dItmHtml = _dItmHtml+number;
			_dItmHtml = _dItmHtml+"</td>";
			_dItmHtml = $(_dItmHtml)
			_dDom.append(_dItmHtml);
			return _dItmHtml;
		},
		setTdWidth:function(_td,_th){
			var _tdWidth=_td.width()+5;
			var _thWidth = $(_th).width()+5;
			if(_tdWidth>_thWidth){
				$(_th).css("min-width",_tdWidth);
				$(_td).css("min-width",_tdWidth);
			}else{
				$(_td).css("min-width",_thWidth);
				$(_th).css("min-width",_thWidth);
			}	
		},
		setBodyWidth:function(_this,_body){
			var bodyHeight = _this.parent().height()-40;
			_body.css({"height":bodyHeight})
		},
		setBodyMethod:function(_this,_body){
			_body.scroll(function() { 
				_this.parent().find(".easytable-header").scrollLeft($(this).scrollLeft()); 
			});
		},
		setPanelWidth:function(_this){
			//先按照100%写
			var style="width:100%;height:100%;overflow:hidden";
			_this.parent().attr("style",style);
		},
		opTdAndThWidth:function(_this,_params){   //处理header与body之间的宽度一致
			var _thisBody=_this.parent().find(".easytable-body");
			var _thisHeader=_this.parent().find(".easytable-header");
			var _headerThTr = _thisHeader.children("tr:first-child");
			var _bodyTdTr = _thisBody.children("tr:first-child");
			var _td,_th,_thisField="";
			var _thFieldArr=[];  //存在重名的列导致表格不能对其:准确或得到同名列是第几个位置
			_bodyTdTr.find("td").each(function(){
				_thisField = $(this).attr("field");
				_td="",_th="";
				_td = $(this);
				_th = _headerThTr.find("th[field="+_thisField+"]");
				if(_thFieldArr[_thisField]) {
					_th = $(_th[_thFieldArr[_thisField]])
					_thFieldArr[_thisField]++;
				}else if(_thFieldArr[_thisField]==undefined) {
					_thFieldArr[_thisField]=1;
				}
				
				opDomDao.setTdWidth(_td,_th);
			});
			
		},
		opThPaddingRight:function(_this,_params){   //处理header与body之间的宽度一致
			var _thisBody=_this.parent().find(".easytable-body");
			var _thisHeader=_this.parent().find(".easytable-header");
			var _headerThTr = _thisHeader.children("tr:first-child");
			if(_thisBody[0].scrollHeight>_thisBody[0].clientHeight){
				_thisHeader.css({"margin-right":"20px"})
			}
		},
		onClickCell:function(_this,_params){
			_this.parent().find(".easytable-body").find("td").each(function(){
            	$(this).on("click",function(){
	            	_params.onClickCell($(this).attr("field"));	
	            }) 	
            })
		},
		onClickRow:function(_this,_params){
			_this.parent().find(".easytable-body").find(".easytable-row").each(function(){
            	$(this).on("click",function(){
	            	if(_params.singleSelect){
		            	$.fn.easyTable.methods["onUnSelectAll"](_this);
		            }
	            	
	            	$(this).toggleClass("easytable-row-over");
	            }) 	
            })
		},
		
	}
	
	var defaults = {
		columns:[],
		data:{rows:[],totle:0},
		url:"",
		nowrap:false,
		queryParams:{},
		rownumbers:true,
		singleSelect:false,
	}

	$.fn.easyTable = function (_params,_options) {
		var _this = $(this);
		
		 if (typeof _params == 'string') {
            return $.fn.easyTable.methods[_params](_this,_options);
        }
		
		var _params = $.extend({},defaults,_params);
		var columns = _params.columns;
		var date = _params.date;
		_opDomSevice.createDom(_this,_params);     		//dom生成
		_opDomSevice.preDispose(_this,_params);	   		//处理数据
		_opDomSevice.initTile(_this,_params.columns);	//生成表头
		_opDomSevice.initData(_this,_params);			//加载数据
		return this;
	};
	
	$.fn.easyTable.methods = {
		destroy:function(_this){
			$(_this).parent().find(".easytable-header").remove();
			$(_this).parent().find(".easytable-body").remove();
			$(_this).parent().find(".easytable-footer").remove();
			return _this;
		},
		onSelectAll:function(_this){
			return "";
		},
		onUnSelectAll:function(_this){
			return $(_this).parent().find(".easytable-body").find(".easytable-row-over").each(function(){
				$(this).removeClass("easytable-row-over");	
			});
		},
	}
})(jQuery);