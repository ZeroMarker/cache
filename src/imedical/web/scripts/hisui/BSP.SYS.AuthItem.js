/// tbl-main
		function _pagerFilter(data){
            if (typeof data.length == 'number' && typeof data.splice == 'function'){    // 判断数据是否是数组
                data = {
                    total: data.length,
                    rows: data
                }
            }
            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');
            pager.pagination({
                onSelectPage:function(pageNum, pageSize){
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh',{
                        pageNumber:pageNum,
                        pageSize:pageSize
                    });
                    dg.datagrid('loadData',data);
                }
            });
            if (!data.originalRows){
                data.originalRows = (data.rows);
            }
            var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }
	function showPAMGrantGrid(itemDesc,data){
		var mytDivObj = $('#pamgrantdiv');
		if (mytDivObj.length==0){
			mytDivObj = $('<div id="pamgrantdiv"></div>').appendTo("body");
		}
		mytDivObj.dialog({
			title:"有【"+itemDesc+"】的权限列表",
			modal:true,isTopZindex:true,width:460,height:500,maximizable:false,resizable:true,
			content: '<table id="pamgrantgrid"></table>'			
		}).show();
		$("#pamgrantgrid").datagrid({
			columns:[[{field:"name",title:"权限类型"},{field:"value",title:"拥有权限的人/岗位"}]],
			pageSize:100,showPageList:false,loadFilter:_pagerFilter,border:false,fit:true,pagination:true
		}).datagrid('loadData',data);
	}
	
	
function init(){
	var applyIf= function(object, config) {
        var property;
        if (object) {
            for (property in config) {
                if (config.hasOwnProperty(property) && object[property] === undefined) {
	                object[property] = config[property];
	            }
            }
        }
        return object;
    };
	$("#grid").mgrid({
		fitColumns:false,
		fit:true,
		editGrid:true,
		codeField:"TAuthCode",
		className:"BSP.SYS.BL.AuthItem",
		queryName:"Find",
		onBeforeLoad:function(param){
			param.AuthCode = $('#AuthCode').val();
			param.AuthModuleCode = $('#AuthModuleCode').val();
			param.AuthAppCode = $('#AuthAppCode').val();
		},
		onColumnsLoad:function(cm){
			var defaultCm = [
				{field:"TID",hidden:true},
				{field:'TAuthAppCode',width:150,editor:{type:'text'}},
				{field:'TAuthModuleCode',width:60,editor:{type:'text'}},
				{field:'TAuthCode',width:250,editor:{type:'text'},formatter:function(val,row){
					if (row["TPreferencesVal"] && row["TPreferencesVal"]=="[]") return val;
					return '<a herf="javascript:void(0)" style="cursor: pointer;" onclick=\'showPAMGrantGrid("'+row["TAuthCaption"]+'",'+row["TPreferencesVal"]+');return false;\'>'+val+'</a>';
				}},
				{field:'TAuthCaption',width:260,editor:{type:'text'}},
				{field:'TAuthSrcUrl',width:80,editor:{type:'text'},formatter:function(val,row){
					if (!val) return "";
					return '<a herf="javascript:void(0)" style="cursor: pointer;" onclick="websys_createWindow(\''+val+'\');return false;">查看配置</a>';
				}},
				{field:'TCBClassName',width:300,editor:{type:'text'}},
				{field:'TCBMethodName',width:260,editor:{type:'text'}}
			];
			for (var i=0;i<cm.length;i++){
				var defaultObj = $.hisui.getArrayItem(defaultCm,'field',cm[i].field)
				if (defaultObj){
					applyIf(cm[i],defaultObj);
				}
			}
		},
		delHandler:function(row){
			var _t=this;
			$.messager.confirm("删除","该操作会删除记录，确定删除【"+row.TAuthCode+"】记录吗?", function(r){
				if(r){
					$.extend(_t.delReq,{"dto.entity.id":row.TID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		insOrUpdHandler:function(row){
			var param;
			var _t = this;
			if(row.TID==""){
				if(row.TAuthCode==""){
					$.messager.popover({msg:"名称不能为空!",type:"info"});
					return;
				}
				param = _t.insReq;
			}else{
				param = $.extend(_t.updReq,{"dto.entity.id":row.TID});
			}
			$.extend(param,{"dto.entity.AuthAppCode":row.TAuthAppCode,"dto.entity.AuthModuleCode":row.TAuthModuleCode,
			"dto.entity.AuthCode":row.TAuthCode,"dto.entity.AuthCaption":row.TAuthCaption,"dto.entity.CBClassName":row.TCBClassName,
			"dto.entity.CBMethodName":row.TCBMethodName,"dto.entity.AuthSrcUrl":row.TAuthSrcUrl});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {TID:"",TAuthAppCode:"",TAuthModuleCode:"",TAuthCode:"",TCBClassName:"",TCBMethodName:"",TAuthSrcUrl:""};	
		}
	});
	$("#btn-find").click(function(){
		$("#grid").datagrid('reload');
	});
	$("#btn-clear").click(function(){
		$('#AuthCode').val('');
		$('#AuthModuleCode').val('');
		$('#AuthAppCode').val('');
		$("#btn-find").click();
	});
	$('#AuthCode,#AuthModuleCode,#AuthAppCode').on('keydown',function(e){
		if (e.keyCode==13){
			$("#btn-find").click();
		}
	});
}
$(init);