/*html*/
var bodyhtml = "<div id='Loading' style=\"position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#DDDDDB;text-align:center;padding-top: 20%;\"><h1><image src='../skin/default/images/loading.gif'/><font color=\"#15428B\">�����С�����</font></h1></div>"
+'<DIV id="PageContent">'
+"<div class=tbToolbar>"
+"</div>"
+'<input TYPE="HIDDEN" id="RowID" name="RowID" value="" /><TABLE width="100%"><TBODY><TR><TD class=defaulttitle>�ͻ��˶�̬��ά��</TD></TR><TR><TD class=i-tableborder><TABLE width="100%"><TBODY><TR><TD><P align=right><label id="cCode">�ؼ�����</label></P></TD><TD>'
+'<input id="Code" name="Code" style="" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cVersion">DLL���汾</label></P></TD><TD>'
+'<input id="Version" name="Version" style="" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cAss">������</label></P></TD><TD>'
+'<input id="Ass" name="Ass" style="width:300px" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cIsVis">�Ƿ�ɼ�</label></P></TD><TD>'
+'<input class="hisui-checkbox" id="IsVis" name="IsVis" type="checkbox"   /></TD><TD>'
+'<a id="Find" name="Find" class="hisui-linkbutton" data-options="disabled:false,iconCls:\'icon-w-find\'">��ѯ</a></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD><P align=right><label id="cDomId">����ID��</label></P></TD><TD>'
+'<input id="DomId" name="DomId" style="" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cNote">����˵��</label></P></TD><TD>'
+'<input id="Note" name="Note" style="" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cCls">����</label></P></TD><TD>'
+'<input id="Cls" name="Cls" style="width:300px" value="" class="hisui-validatebox textbox"/></TD><TD><P align=right><label id="cActive">�Ƿ񼤻�</label></P></TD><TD>'
+'<input class="hisui-checkbox" id="Active" name="Active" type="checkbox"   /></TD><TD>'
+'<a id="Clean" name="Clean" class="hisui-linkbutton" data-options="disabled:false,iconCls:\'icon-w-clean\'">���</a></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD><P align=right><label id="cSubPath">DLL�ļ�·��</label></P></TD><TD>'
+'<input id="SubPath" name="SubPath" style="width:800px" value="" class="hisui-validatebox textbox"/></TD><TD>&nbsp;</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD>'
+'<a id="Ins" name="Ins" class="hisui-linkbutton" data-options="disabled:false,iconCls:\'icon-w-add\'">����</a></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD><P align=right><label id="cAssDir">·��</label></P></TD><TD>'
+'<input id="AssDir" name="AssDir" style="width:800px" value="" class="hisui-validatebox textbox" data-options=" prompt:\'ֻ���޸�IP\'" /></TD><TD>&nbsp;</TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD>'
+'<a id="Save" name="Save" class="hisui-linkbutton" data-options="disabled:false,iconCls:\'icon-w-save\'">����</a></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD><P align=right><label id="cClientIPExp">�ͻ���IP</label></P></TD><TD>'
+'<input id="ClientIPExp" name="ClientIPExp" style="" value="" class="hisui-validatebox textbox" data-options=" prompt:\'��ЩIP��Ҫ���¡���ʽ��192.168.1.[18-200] ��192.168.[2-4].* �� 10.*.10.1����������ö��ŷָ\'" /></TD><TD>&nbsp;'
+'<input id="NewItem71" name="NewItem71" style="" value="" class="hisui-validatebox textbox"/></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE><TABLE width="100%"><TBODY><TR><TD class=listtitle>��̬���б�</TD></TR><TR><TD class=i-tableborder><table id="twebsys_AddIns" style="height:400px;"></table></TD></TR></TBODY></TABLE>'
+'<div><span><!--54486,websys.AddIns--></span></div>'
+'</DIV>'

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
	data["dto.addIns.ClientIPExp"]=getValueById("ClientIPExp");
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
	setValueById("ClientIPExp","");
	return data;
};
function reSizeInput(id){
	$("#"+id).css({position: "absolute",width: "800px",marginTop: "-15px"})
}
function init(){
	//$(bodyhtml).appendTo("#PageContent");
	//$.parser.parse("#PageContent");
	reSizeInput("SubPath");
	reSizeInput("AssDir");
	reSizeInput("ClientIPExp");
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
			$.messager.popover({msg: 'ȱʧID',type:'alert',timeout: 2000});
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
			title:'ά��'+Code+'����',
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
			title:'�����б�',
			getReq:{QueryName:"LookUpMths",RowId:RowId},
			columns:[[
				{field:'MthName',title:'������',width:120,editor:{type:'text'}},
				{field:'RunClear',title:'�������',width:60,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
				{field:'RunInvk',title:'��ʱ����',width:60,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
			]],
			insOrUpdHandler:function(row){
				$("#"+this.key+'AddBtn').trigger('click');
			},
			getNewRecord:function(){
				return {MthName:"",RunClear:"N",RunInvk:"N"};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.MthName+"��������?", function (r) {
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
			title:'ά��'+Code+'����',
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
			title:'�����б�',
			getReq:{QueryName:"LookUpProps",RowId:RowId},
			columns:[[
				{field:'PropName',title:'������',width:120,editor:{type:'text'}}
			]],
			insOrUpdHandler:function(row){
				$("#"+this.key+'AddBtn').trigger('click');
			},
			getNewRecord:function(){
				return {PropName:""};
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.PropName+"��������?", function (r) {
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