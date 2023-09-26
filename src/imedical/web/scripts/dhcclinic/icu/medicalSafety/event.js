
function InitViewScreenEvent(obj)
{
	
	var _DHCCLMedicalSafety=ExtTool.StaticServerObject('web.DHCCLMedicalSafety');
	var _DHCICUCom=ExtTool.StaticServerObject('web.DHCICUCom');
	
	obj.LoadEvent = function(args)
	{
		var url=location.search; 
	    //var Request = new Object();
	    if(url.indexOf("?")!=-1) {         
	    var str = url.substr(1)    //ȥ��ȥ��ȥ��ȥ��?�źźź�         
	    strs = str.split("&");
	    for(var i=0;i<strs.length;i++)         
	    {               
	    obj[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);         
	    } 
	    }
	    Ext.getDom("EpisodeID").value=obj["EpisodeID"];
	    Ext.getDom("PatName").value=_DHCCLMedicalSafety.GetPatName(obj["EpisodeID"]);
	    Ext.getDom("icuId").value=_DHCICUCom.GetIcuaId(obj["EpisodeID"],"","");

		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCLMedicalSafety';
			param.QueryName = 'MedicalSafety';
			param.Arg1 = obj.icuId.getRawValue();
			param.ArgCnt = 1;
		});
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  

	}
	obj.retGridPanel_rowclick=function() //������ȡ����
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    //obj.Desc.setValue(rc.get("tDesc"));
		    //obj.Code.setValue(rc.get("tCode"));
		    //obj.ctlocDesc.setValue(rc.get("tctloc"));
		    
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
		var EpisodeID=Ext.getDom("EpisodeID").value;
		var icuId=Ext.getDom("icuId").value;
		var CLCMS=Ext.getDom("CLCMS").value;
		if (CLCMS=="") 
		{
			alert("�������¼���");
			return;
		}
		var CLCMSId=obj.CLCMS.getValue()
		var status=obj.status.getValue()
		var note=Ext.getDom("note").value;
		var str=icuId+"^"+CLCMSId+"^"+sessLoc+"^"+status+"^"+note+"^"+sessUser+"^"+EpisodeID;
		var ret=_DHCCLMedicalSafety.AddMedicalSafety(str);
		alert(ret);
				obj.retGridPanelStore.reload();
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
			alert("����ѡ����Ҫ���µļ�¼��");
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
			alert("����ѡ����Ҫɾ���ļ�¼��");
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

