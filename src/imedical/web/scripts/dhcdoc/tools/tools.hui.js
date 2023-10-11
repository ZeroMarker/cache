var DocToolsHUI={
	lib:{
		pagerFilter:function pagerFilter(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				data = {
					total: data.length,
					rows: data
				}
			}
			var dg = $(this);
			var opts = dg.datagrid('options');
			var pager = dg.datagrid('getPager');
			var sortName = opts.sortName;
		    var sortOrder = opts.sortOrder;
		    if (!data.originalRows) {
		        data.originalRows = data.rows;
			}
			if ((!opts.remoteSort)&& (sortName != null)) {	    
		        data.originalRows.sort(function (obj1, obj2) {
		            var val1 = obj1[sortName];
		            var val2 = obj2[sortName];
		            if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
		                val1 = Number(val1);
		                val2 = Number(val2);
		            }
		            var $sorter = dg.datagrid("getColumnOption", sortName).sorter;  //sorter排序方法
		            if ($sorter) {
		                return (sortOrder == "asc") ? $sorter(val1, val2) : $sorter(val2, val1);
		            } else {
		                if(val1<val2){
		                    return (sortOrder == "desc") ? 1 : -1;
		                } else if (val1 > val2) {
		                    return (sortOrder == "desc") ? -1 : 1;
		                } else {
		                    return 0
		                }
		            }
		        })
		    }
			pager.pagination({
				showRefresh:false,
				onSelectPage:function(pageNum, pageSize){
					if (dg[0].id!="tabInPatOrd"){
						dg.datagrid('unselectAll');
					}
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					dg.datagrid('loadData',data);
					dg.datagrid('scrollTo',0); //滚动到指定的行  
					/*
					//特殊处理下信息总览界面的医嘱列表
					刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
					*/
					if (dg[0].id=="tabInPatOrd"){
						setTimeout(function() {
							if (typeof ipdoc !="undefined"){
								if (typeof ipdoc.patord.view.SetVerifiedOrder !="undefined"){
									ipdoc.patord.view.SetVerifiedOrder(true);
								}
							}
							//SetVerifiedOrder(true);
						}, 0);
					}      
				},onChangePageSize:function(pageSize){
					if (typeof opts.onChangePageSize == "function"){
						opts.onChangePageSize(pageSize);
					}
				}
			});
			if (!data.originalRows){
				data.originalRows = (data.rows);
			}
			if (opts.pagination){
				if (data.originalRows.length>0) {
					var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
					if ((start+1)>data.originalRows.length){
						//取现有行数最近的整页起始值
						start=Math.floor((data.originalRows.length<1?1:data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
						opts.pageNumber=(start/opts.pageSize)+1;
					}
					//解决页码显示不正确的问题
					$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
					
					var end = start + parseInt(opts.pageSize);
					data.rows = (data.originalRows.slice(start, end));
				}
			}
			return data;
		}
	},
	MessageQueue:{
		Queue: {},
		Add: function(MsgType,$Msg){
			if ((typeof MsgType=="undefined")||(typeof $Msg=="undefined")){
				return;   
			}
			if (this.Queue[MsgType] instanceof Array ===false){
			   this.Queue[MsgType]=new Array();
			}
			this.Queue[MsgType].push($Msg);
			return $Msg;
		},
		///批量停止执行Ajax请求，防止相同的请求对同一DOM操作，导致界面数据异常
		FireAjax:   function (MsgType) {
			this.EachDel(MsgType,function($Ajax){
				if($Ajax.readyState == 4 && $Ajax.status == 200) {
					return;
				}
				$Ajax.abort();
			});
		},
		EachDel:   function (MsgType,callBack) {
			if (this.Queue[MsgType] instanceof Array ===false){
				return;
			}
		    var $Msg;
			for(var i=0; i<this.Queue[MsgType].length; i++){
				$Msg=this.Queue[MsgType][i];
				this.Queue[MsgType].splice(i--, 1);
				if (callBack($Msg)===false){
					break;
				}
			}
         }
	}
};

var DocLogObj={
	SaveInterfaceLog:function(LogCode,Options,OutParams){
		if (LogCode=="") return "";
		var JsonObj={"NodeSeqNo":"","NodeDesc":""};
		if ("object" == typeof Options && Options !== null) {
        	JsonObj.NodeSeqNo=Options.NodeSeqNo||"";		//节点序号
        	JsonObj.NodeDesc=Options.NodeDesc||"";			//节点描述
		}
		var JsonStr=JSON.stringify(JsonObj);	
		
		var args=new Array("web.DHCDocInterfaceLog","SaveInterfaceLog",LogCode,JsonStr,OutParams);
		for (var i=3; i<arguments.length; i++) {
			var length=args.length;
			args[length]=arguments[i];
		}
		var retval=tkMakeServerCall.apply(this, args);
		return retval;
	
	}
};
//HISUI menu方法扩展 目前给住院医嘱另存医嘱模板使用
(function($){
	$.extend($.fn.menu.methods, {    
		showItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).show().next('.menu-sep').show();  
				}else{
					$(itemEl).show().next('.menu-sep').show();  
				}  
				$(this).menu('resize');
			});    
		},
		hideItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).hide().next('.menu-sep').hide();  
				}else{
					$(itemEl).hide().next('.menu-sep').hide();  
				}
				$(this).menu('resize');    
			});    
		},
		resize:function(jq){    
			return jq.each(function(){  
				var height=0,$obj=$(this).children(':visible');
				for(var i=0;i<$obj.size();i++)
					height+=$obj.eq(i).outerHeight();
				$(this).height(height+12).next('.menu-shadow').height(height+14);  
			});    
		},
		removeSubMenu:function(jq,target){
			return jq.each(function(){  
				if(target.submenu){
					if(target.submenu[0].shadow){
						target.submenu[0].shadow.remove();
					}
					target.submenu.remove();
					delete target.submenu;
				}
			});
		},
		getSubMenu:function(jq,target){
			return target.submenu;
		}
	}); 
})(jQuery);