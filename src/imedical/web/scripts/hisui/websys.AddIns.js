
/*websys.AddIns.js*/
var getData = function(){
	var data = {};
	data["dto.addIns.Active"]=getValueById("Active")?"Y":"N";
	data["dto.addIns.Ass"]=getValueById("Ass");
	data["dto.addIns.AssDir"]=getValueById("AssDir");
	data["dto.addIns.ClassId"]=getValueById("ClassId");
	data["dto.addIns.Cls"]=getValueById("Cls");
	data["dto.addIns.Code"]=getValueById("Code");
	data["dto.addIns.DomId"]=getValueById("DomId");
	data["dto.addIns.IsVis"]=getValueById("IsVis")?"Y":"N";
	//data["dto.addIns.Mths"]=getValueById("Mths");
	data["dto.addIns.Note"]=getValueById("Note");
	data["dto.addIns.SubPath"]=getValueById("SubPath");
	data["dto.addIns.Version"]=getValueById("Version");
	return data;
};
var clearData = function(){
	var data = {};
	setValueById("RowID","");
	setValueById("Active",false);
	setValueById("Ass","");
	setValueById("AssDir","");
	setValueById("ClassId","");
	setValueById("Cls","");
	setValueById("Code","");
	setValueById("DomId","");
	setValueById("IsVis",false);
	setValueById("Note","");
	setValueById("SubPath","");
	setValueById("Version","");
	return data;
};
function init(){
	$("#Ins").click(function(){
		var data = getData();
		$cm($.extend({
			ClassName:"websys.dto.AddIns",
			MethodName:"Insert",
			"dto.gridId":"twebsys_AddIns"
		},data),defaultCallBack);
	});
	$("#Save").click(function(){
		var data = {};
		var id = getValueById("RowID");
		if (id>0){
			var data = getData();
			data["dto.addIns.id"]=id;
			$cm($.extend({
				ClassName:"websys.dto.AddIns",
				MethodName:"Update",
				"dto.gridId":"twebsys_AddIns"
			},data),defaultCallBack)
		}else{
			$.messager.popover({msg: '缺失ID',type:'alert',timeout: 2000});
			return ;
		}
	});
	$("#Clean").click(function(){
		clearData();
	});
	$("#twebsys_AddIns").datagrid("options").onClickRow = function(ind,row){
		for(var i in row){
			setValueById(i.slice(1),row[i]);
		}
	}
}
websys_lu_bak = websys_lu;
websys_lu = function(url,flag,opt){
	if (url.indexOf("iTMths")>-1){
		var RowId = url.match(/RowId=(.+?)&/)[1];
		var Code = url.match(/Code=(.+?)&/)[1];
		
		var mthGridWinJObj = $("#mthsGridWin");
		if (mthGridWinJObj.length==0){
			mthGridWinJObj = $("<div id='mthsGridWin'></div>").append("body");
		}
		mthGridWinJObj.dialog({
			title:'维护'+Code+'方法',
			content:'<table id="mthsGrid"></table>',
			width:560,
			height:392,
			onBeforeClose:function(){
				if ($("#mthsGrid").datagrid){
					var MthsNameArr = $("#mthsGrid").datagrid('getRows');
					var MthsName = ",";
					$.each(MthsNameArr,function(i,item){
						if(item.MthName!=""){
							MthsName += item.MthName+"|"+item.RunClear+"|"+item.RunInvk+","
						}
					});
					$cm({ClassName:"websys.dto.AddIns",MethodName:"SaveMthName",
					"dto.mthsName":MthsName,
					"dto.addIns.id":RowId,
					"dto.gridId":"twebsys_AddIns"
					},defaultCallBack)
				}
				return true;
			}
		});
		createDatagridEdit({
			className:'websys.dto.AddIns',
			key:'mths',
			//gridContent:top,
			title:'方法列表',
			getReq:{QueryName:"LookUpMths",RowId:RowId},
			columns:[[
				{field:'MthName',title:'方法名',width:120,editor:{type:'text'}},
				{field:'RunClear',title:'调用清除',width:60,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
				{field:'RunInvk',title:'即时调用',width:60,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
			]],
			insOrUpdHandler:function(row){
				$("#"+this.key+'AddBtn').trigger('click');
			},
			getNewRecord:function(){
				return {MthName:"",RunClear:"N",RunInvk:"N"};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "确定删除【"+row.MthName+"】方法名?", function (r) {
					if (r) {
						var ind = $("#"+_t.key+"Grid").datagrid('getRowIndex',row);
						$("#"+_t.key+"Grid").datagrid('deleteRow', ind);
					}
				});
			}
		});
	}else if (url.indexOf("iTProps")>-1){
		var RowId = url.match(/RowId=(.+?)&/)[1];
		var Code = url.match(/Code=(.+?)&/)[1];
		
		var mthGridWinJObj = $("#propsGridWin");
		if (mthGridWinJObj.length==0){
			mthGridWinJObj = $("<div id='propsGridWin'></div>").append("body");
		}
		mthGridWinJObj.dialog({
			title:'维护'+Code+'属性',
			content:'<table id="propsGrid"></table>',
			width:560,
			height:392,
			onBeforeClose:function(){
				if ($("#propsGrid").datagrid){
					var PropNameArr = $("#propsGrid").datagrid('getRows');
					var PropName = ",";
					$.each(PropNameArr,function(i,item){
						if(item.PropName!=""){
							PropName += item.PropName+","
						}
					});
					$cm({ClassName:"websys.dto.AddIns",MethodName:"SavePropName",
					"dto.propsName":PropName,
					"dto.addIns.id":RowId,
					"dto.gridId":"twebsys_AddIns"
					},defaultCallBack)
				}
				return true;
			}
		});
		createDatagridEdit({
			className:'websys.dto.AddIns',
			key:'props',
			//gridContent:top,
			title:'属性列表',
			getReq:{QueryName:"LookUpProps",RowId:RowId},
			columns:[[
				{field:'PropName',title:'属性名',width:120,editor:{type:'text'}}
			]],
			insOrUpdHandler:function(row){
				$("#"+this.key+'AddBtn').trigger('click');
			},
			getNewRecord:function(){
				return {PropName:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "确定删除【"+row.PropName+"】属性名?", function (r) {
					if (r) {
						var ind = $("#"+_t.key+"Grid").datagrid('getRowIndex',row);
						$("#"+_t.key+"Grid").datagrid('deleteRow', ind);
					}
				});
			}
		});
	}else{
		websys_lu_bak(url,flag,opt);
	}
}
$(init);