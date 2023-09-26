function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCANCViewCat=ExtTool.StaticServerObject('web.DHCANCViewCat');
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		  SelectedRowID=rc.get("tRowid");
		  if(preRowID!=SelectedRowID)
		  {
			  obj.tRowid.setValue(rc.get("tRowid"));
			  obj.viewsupcatId.setValue(rc.get("tANCVSCId"));
			  obj.viewcode.setValue(rc.get("tAncvcCode"));
			  obj.viewname.setValue(rc.get("tAncvcDesc"));
			  obj.venipuncture.setValue(rc.get("tAncvcVPSite"));
			  obj.viewvital.setValue(rc.get("tAncvcVs"));
			  obj.viewevent.setValue(rc.get("tAncvcEvent"));
			  obj.viewphy.setValue(rc.get("tAncvcOrder"));
			  obj.viewhealth.setValue(rc.get("tAncvcTherapy"));
			  obj.viewcheck.setValue(rc.get("tAncvcLab"));
			  obj.viewcat.setValue(rc.get("tAncvcDisplayByCat"));
			  obj.viewsupcat.setValue(rc.get("tANCVSCId"));
			  obj.viewsupcat.setRawValue(rc.get("tANCVSCDesc"));
			  obj.totaltype.setValue(rc.get("tAncvcSummaryType"));
			  obj.choice.setValue(rc.get("tOptions"));
			  obj.ANCOViewCatDr.setValue(rc.get("tANCOViewCatDr"));
			  obj.ANCOViewCatDr.setRawValue(rc.get("tANCOViewCatDesc"));
			  var ViewCatIdlist=(rc.get("tANCOViewCatDr")).split(";");
			  var ViewCatDesclist=(rc.get("tANCOViewCatDesc")).split(";")
			  objListStore=obj.listANCOViewCatDr.getStore(); 
			  objListStore.removeAll();
			  for(i=0;i<ViewCatIdlist.length;i++)
			  {
				  ViewCatId=ViewCatIdlist[i];
				  ViewCatDesc=ViewCatDesclist[i];
				  addToList(ViewCatId,ViewCatDesc,obj.listANCOViewCatDr);
			  }
			  preRowID=SelectedRowID;
	    }
	    else
		{
			  obj.tRowid.setValue("");
			  obj.viewsupcatId.setValue("");
			  obj.viewcode.setValue("");
			  obj.viewname.setValue("");
			  obj.venipuncture.setValue("");
			  obj.viewvital.setValue("");
			  obj.viewevent.setValue("");
			  obj.viewphy.setValue("");
			  obj.viewhealth.setValue("");
			  obj.viewcheck.setValue("");
			  obj.viewcat.setValue("");
			  obj.viewsupcat.setValue("");
			  obj.viewsupcat.setRawValue("");
			  obj.totaltype.setValue("");
			  obj.choice.setValue("");
			  obj.ANCOViewCatDr.setValue("");
			  obj.ANCOViewCatDr.setRawValue("");
			  objListStore=obj.listANCOViewCatDr.getStore(); 
			  objListStore.removeAll();
			  SelectedRowID = 0;
			  preRowID=0;
			  obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		}
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.viewcode.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���ʹ��벻��Ϊ��!");	
			return;
		}
		if(obj.viewname.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ�������Ʋ���Ϊ��!");	
			return;
		}
		if(obj.viewsupcat.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var viewcode=obj.viewcode.getValue();           //��ʾ���ʹ���
		var viewname=obj.viewname.getValue();           //��ʾ��������
		var viewvital=obj.viewvital.getValue();         //��ʾ��������
		if(viewvital=="1") viewvital="Y"
		if(viewvital=="0") viewvital="N"
		var viewphy=obj.viewphy.getValue();             //��ʾ��ҩ
		if (viewphy=="1") viewphy="Y"
		if (viewphy=="0") viewphy="N"
		var viewevent=obj.viewevent.getValue();         //��ʾ�¼�
		if(viewevent=="1") viewevent="Y"
		if(viewevent=="0") viewevent="N"
		var venipuncture=obj.venipuncture.getValue();   //��������
		if (venipuncture=="1") venipuncture="Y"
		if (venipuncture=="0") venipuncture="N"
		var viewhealth=obj.viewhealth.getValue();       //��ʾ����
		if (viewhealth=="1") viewhealth="Y"
		if (viewhealth=="0") viewhealth="N"
		var viewcheck=obj.viewcheck.getValue();          //��ʾ����
		if (viewcheck=="1") viewcheck="Y"
		if (viewcheck=="0") viewcheck="N"
		var anapply="Y";	//20150313+dyl+��ע��an��������ģ�����������
		var icuapply="N";
		var ancvscId=obj.viewsupcat.getValue();
		var viewcat=obj.viewcat.getValue();               //��������ʾ
		if (viewcat=="1") viewcat="Y"
		if (viewcat=="0") viewcat="N"
		var totaltype=obj.totaltype.getValue();           //��������
		var choice=obj.choice.getValue();                 //ѡ��
        var ANCOViewCatDr="";                             //��ʾ���������
		var objListStore=new Ext.data.Store;
		objListStore=obj.listANCOViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ANCOViewCatDr=="")
			{
				ANCOViewCatDr=CatId;
			}
			else
			{
				ANCOViewCatDr=ANCOViewCatDr+";"+CatId;
			}
		}
		//alert(ANCOViewCatDr+","+choice);
        //alert(viewcode+"^"+viewname+"^"+viewvital+"^"+viewphy+"^"+viewevent+"^"+venipuncture+"^"+viewhealth+"^"+viewcheck+"^"+anapply+"^"+icuapply+"^"+ancvscId+"^"+viewcat+"^"+totaltype+"^"+choice)
		var ret=_DHCANCViewCat.InsertANCViewCat(viewcode,viewname,viewvital,viewphy,viewevent,venipuncture,viewhealth,viewcheck,anapply,icuapply,ancvscId,viewcat,totaltype,choice,ANCOViewCatDr);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
	  	  	obj.tRowid.setValue("");
	  	  	obj.viewcode.setValue("");
	  	  	obj.viewname.setValue("");
	  	  	obj.viewvital.setValue("");
	  	  	obj.viewphy.setValue("");
	  	  	obj.viewevent.setValue(""); 
	  	  	obj.venipuncture.setValue(""); 
	  	  	obj.viewhealth.setValue("");
	  	  	obj.viewcheck.setValue("");
	  	  	var anapply="";
	  	  	var icuapply="";
	  	  	obj.viewsupcat.setValue("");
	  	  	obj.viewcat.setValue("");
	  	  	obj.totaltype.setValue("");
	  	  	obj.choice.setValue("");
	  	  	obj.ANCOViewCatDr.setValue("");
	  	  	//obj.listANCOViewCatDr.setValue("");
	  	  	obj.retGridPanelStore.load({});  
	  	  	objListStore=obj.listANCOViewCatDr.getStore(); 
			objListStore.removeAll();	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.tRowid.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼IdΪ��!");	
			return;
		}
		if(obj.viewcode.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���ʹ��벻��Ϊ��!");	
			return;
		}
		if(obj.viewname.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ�������Ʋ���Ϊ��!");	
			return;
		}
		if(obj.viewsupcat.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return;
		}
		var tRowid = obj.tRowid.getValue();
		var viewcode=obj.viewcode.getValue();           //��ʾ���ʹ���
		var viewname=obj.viewname.getValue();           //��ʾ��������
		var viewvital=obj.viewvital.getValue();         //��ʾ��������
		if(viewvital=="1") viewvital="Y"
		if(viewvital=="0") viewvital="N"
		var viewphy=obj.viewphy.getValue();             //��ʾ��ҩ
		if (viewphy=="1") viewphy="Y"
		if (viewphy=="0") viewphy="N"
		var viewevent=obj.viewevent.getValue();         //��ʾ�¼�
		if(viewevent=="1") viewevent="Y"
		if(viewevent=="0") viewevent="N"
		var venipuncture=obj.venipuncture.getValue();   //��������
		if (venipuncture=="1") venipuncture="Y"
		if (venipuncture=="0") venipuncture="N"
		var viewhealth=obj.viewhealth.getValue();       //��ʾ����
		if (viewhealth=="1") viewhealth="Y"
		if (viewhealth=="0") viewhealth="N"
		var viewcheck=obj.viewcheck.getValue();          //��ʾ����
		if (viewcheck=="1") viewcheck="Y"
		if (viewcheck=="0") viewcheck="N"
		var anapply="Y";	//20150313+dyl+��ע��an��������ģ�����������
		var icuapply="N";
		var ancvscId=obj.viewsupcat.getValue();
		var viewcat=obj.viewcat.getValue();               //��������ʾ
		if (viewcat=="1") viewcat="Y"
		if (viewcat=="0") viewcat="N"
		var totaltype=obj.totaltype.getValue();           //��������
		var choice=obj.choice.getValue();                 //ѡ��
        var ANCOViewCatDr="";                             //��ʾ���������
		var objListStore=new Ext.data.Store;
		objListStore=obj.listANCOViewCatDr.getStore();
		for (var i=0;i<objListStore.getCount();i++)
		{
			CatId=objListStore.getAt(i).get('listId');
			if(ANCOViewCatDr=="")
			{
				ANCOViewCatDr=CatId;
			}
			else
			{
				ANCOViewCatDr=ANCOViewCatDr+";"+CatId;
			}
		}
		var ret=_DHCANCViewCat.UpdateANCViewCat(tRowid,viewcode,viewname,viewvital,viewphy,viewevent,venipuncture,viewhealth,viewcheck,anapply,icuapply,ancvscId,viewcat,totaltype,choice,ANCOViewCatDr);
		//alert(ret)
		if(ret!=0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	obj.tRowid.setValue("");
	  	  	obj.viewcode.setValue("");
	  	  	obj.viewname.setValue("");
	  	  	obj.viewvital.setValue("");
	  	  	obj.viewphy.setValue("");
	  	  	obj.viewevent.setValue(""); 
	  	  	obj.venipuncture.setValue(""); 
	  	  	obj.viewhealth.setValue("");
	  	  	obj.viewcheck.setValue("");
	  	  	var anapply="";
	  	  	var icuapply="";
	  	  	obj.viewsupcat.setValue("");
	  	  	obj.viewcat.setValue("");
	  	  	obj.totaltype.setValue("");
	  	  	obj.choice.setValue("");
	  	  	obj.ANCOViewCatDr.setValue("");
	  	  	//obj.listANCOViewCatDr.setValue("");
	  	  	obj.retGridPanelStore.load({});
	  	  	objListStore=obj.listANCOViewCatDr.getStore(); 
			objListStore.removeAll();  
		  	});
	     }
	     obj.retGridPanelStore.load({});  
	 };
	 function addToList(valStrId,valStrDes,objList)
	{
	    
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
	    var rec1= new (objListStore.recordType)();
		var length=objListStore.getCount();
		/*if (length>0)
		{
		     for(i=0;i<length;i++)
		     {
			      listId=objListStore.getAt(i).get('listId');
			      if (valStrId==listId) 
			      {
				      alert("��ʾ�����ظ�!");
				      return;
			      }
		     }
		}*/
	    rec1.set('listDesc',valStrDes);
		rec1.set('listId',valStrId);
	    objListStore.addSorted(rec1);
		objList.bindStore(objListStore);
	}
	 function addCompValToList(objCom,objList)
	{
	    var valStrDes=objCom.getRawValue();
		var valStrId=objCom.getValue();
		//addToList(valStrId,valStrDes,objList);
		//objCom.setRawValue('');
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
	    var rec1= new (objListStore.recordType)();
		var length=objListStore.getCount();
		if (length>0)
		{
		     for(i=0;i<length;i++)
		     {
			      listId=objListStore.getAt(i).get('listId');
			      if (valStrId==listId) 
			      {
				      alert("ѡ���ظ�!");
				      return;
			      }
		     }
		}
	    rec1.set('listDesc',valStrDes);
		rec1.set('listId',valStrId);
	    objListStore.addSorted(rec1);
		objList.bindStore(objListStore);
	}
	
	function delListEl(objList)
	{
		var sel = objList.getSelectedRecords();
		var objListStore=new Ext.data.Store;
		objListStore=objList.getStore();
		objListStore.remove(sel);
		objList.bindStore(objListStore);
	}
		
	obj.ANCOViewCatDr_select =function()
	{
		addCompValToList(obj.ANCOViewCatDr,obj.listANCOViewCatDr);
	}
	obj.listANCOViewCatDr_dblClick=function()
	{
	    delListEl(obj.listANCOViewCatDr);
	}
	obj.deletebutton_click = function()
	{
	  var ID=obj.tRowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCViewCat.DeleteANCViewCat(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else{
		  	Ext.Msg.alert("��ʾ","ɾ���ɹ�!",function(){
		  	  	obj.tRowid.setValue("");
		  	  	obj.viewcode.setValue("");
		  	  	obj.viewname.setValue("");
		  	  	obj.viewvital.setValue("");
		  	  	obj.viewphy.setValue("");
		  	  	obj.viewevent.setValue(""); 
		  	  	obj.venipuncture.setValue(""); 
		  	  	obj.viewhealth.setValue("");
		  	  	obj.viewcheck.setValue("");
		  	  	var anapply="";
		  	  	var icuapply="";
		  	  	obj.viewsupcat.setValue("");
		  	  	obj.viewcat.setValue("");
		  	  	obj.totaltype.setValue("");
		  	  	obj.choice.setValue("");
		  	  	obj.ANCOViewCatDr.setValue("");
		  	  	//obj.listANCOViewCatDr.setValue("");
		  	  	obj.retGridPanelStore.load({});  
		  	  	objListStore=obj.listANCOViewCatDr.getStore(); 
				objListStore.removeAll();	
		  	  	});
		  	}
		  	//obj.retGridPanelStore.removeAll();
	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANCViewCat';
			param.QueryName = 'FindANCViewCat';
			//param.Arg1 = 'OpaStatus';
			param.Arg1 = 'N';
			param.Arg2 = obj.checkall.getValue()?'Y':'N';
			param.Arg3 = obj.viewname.getValue();
			param.ArgCnt = 3;
		});
		obj.retGridPanelStore.load({});
  	  	obj.tRowid.setValue("");
  	  	obj.viewcode.setValue("");
  	  	obj.viewname.setValue("");
  	  	obj.viewvital.setValue("");
  	  	obj.viewphy.setValue("");
  	  	obj.viewevent.setValue(""); 
  	  	obj.venipuncture.setValue(""); 
  	  	obj.viewhealth.setValue("");
  	  	obj.viewcheck.setValue("");
  	  	var anapply="";
  	  	var icuapply="";
  	  	obj.viewsupcat.setValue("");
  	  	obj.viewcat.setValue("");
  	  	obj.totaltype.setValue("");
  	  	obj.choice.setValue("");
  	  	obj.ANCOViewCatDr.setValue("");
  	  	//obj.listANCOViewCatDr.setValue("");
  	  	objListStore=obj.listANCOViewCatDr.getStore(); 
		objListStore.removeAll();
		obj.intCurrRowIndex = -1;
	};
}