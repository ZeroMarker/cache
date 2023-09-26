
function InitViewScreenEvent(obj)
{
	var _DHCCLMedicalSafety=ExtTool.StaticServerObject('web.DHCCLMedicalSafety');
	var _DHCICUCom=ExtTool.StaticServerObject('web.DHCICUCom');
	
	obj.LoadEvent = function(args)
	{
		var url=location.search; 
	    //var Request = new Object();
	    if(url.indexOf("?")!=-1) {         
	    var str = url.substr(1)    //去掉去掉去掉去掉?号号号号         
	    strs = str.split("&");
	    for(var i=0;i<strs.length;i++)         
	    {               
	    obj[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);         
	    } 
	    }
	    Ext.getDom("EpisodeID").value=obj["EpisodeID"];
	    Ext.getDom("PatName").value=_DHCCLMedicalSafety.GetPatName(obj["EpisodeID"]);
	    Ext.getDom("opaId").value=obj["opaId"];

		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCLMedicalSafety';
			param.QueryName = 'MedicalSafetyAn';
			param.Arg1 = Ext.getDom("opaId").value;
			param.ArgCnt = 1;
		});
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  

	}
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    
		    var tEventDesc=selectObj.get('tEventDesc');
		    var tEventId=selectObj.get('tEventId');
		    var tstatusDesc=selectObj.get('tstatusDesc');
		    var tstatusCode=selectObj.get('tstatusCode');
		    var tnote=selectObj.get('tnote');
		    var trowId=selectObj.get('trowId');
		    Ext.getDom("CLCMS").value=tEventDesc;
		    obj.CLCMS.setValue(tEventId);
		    Ext.getDom("status").value=tstatusDesc;
		    obj.status.setValue(tstatusCode);
		    Ext.getDom("note").value=tnote;
		    Ext.getDom("rowId").value=trowId;
		   
	    }
	}
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
	}
	obj.btnAdd_click = function()
	{
		var sessLoc=session['LOGON.CTLOCID'];
		var sessUser=session['LOGON.USERID'];
		var opaId=Ext.getDom("opaId").value;
		var EpisodeID=Ext.getDom("EpisodeID").value;
		var CLCMS=Ext.getDom("CLCMS").value;
		if (CLCMS=="") 
		{
			alert("请输入事件！");
			return;
		}
		var CLCMSId=obj.CLCMS.getValue()
		var status=obj.status.getValue()
		var note=Ext.getDom("note").value;
		var str=opaId+"^"+CLCMSId+"^"+sessLoc+"^"+status+"^"+note+"^"+sessUser+"^"+EpisodeID;
		var ret=_DHCCLMedicalSafety.AddMedicalSafetyAn(str);
		alert(ret);
		Ext.getDom("CLCMS").value="";
		obj.CLCMS.setValue("");
		Ext.getDom("status").value="";
		obj.statusS.setValue("");
		Ext.getDom("note").value="";
	}
	obj.btnUpdate_click = function()
	{
		var rowId=Ext.getDom("rowId").value;
		if (rowId=="")
		{
			alert("请先选择需要更新的记录！");
			return;
		}
		var CLCMSId=obj.CLCMS.getValue()
		var status=obj.status.getValue()
		var note=Ext.getDom("note").value;
		var str=CLCMSId+"^"+status+"^"+note;
		var ret=_DHCCLMedicalSafety.UpdateMedicalSafety(rowId,str);
		alert(ret);
		Ext.getDom("CLCMS").value="";
		obj.CLCMS.setValue("");
		Ext.getDom("status").value="";
		obj.statusS.setValue("");
		Ext.getDom("note").value="";
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		}); 
		
	}
	obj.btnDelete_click = function()
	{
		var rowId=Ext.getDom("rowId").value;
		if (rowId=="")
		{
			alert("请先选择需要删除的记录！");
			return;
		}
		var ret=_DHCCLMedicalSafety.DeleteMedicalSafety(rowId);
		alert(ret);
		Ext.getDom("CLCMS").value="";
		obj.CLCMS.setValue("");
		Ext.getDom("status").value="";
		obj.status.setValue("");
		Ext.getDom("note").value="";
		
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		}); 
		
	}
}

