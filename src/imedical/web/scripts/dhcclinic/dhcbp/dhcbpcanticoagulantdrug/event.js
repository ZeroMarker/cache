function InitViewScreenEvent(obj)
{
	var SelectedRowID = 0;
	var preRowID=0;	
	var _DHCBPCAnticoagulantDrug=ExtTool.StaticServerObject('web.DHCBPCAnticoagulantDrug');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  SelectedRowID=rc.get("tID");
	  if (rc){ 
	  	if(preRowID!=SelectedRowID){
		    obj.Rowid.setValue(rc.get("tID"));
		    obj.drugCode.setValue(rc.get("tBPCADCode"));//ҩƷCode
		    obj.drugName.setValue(rc.get("tBPCADDesc")); //ҩƷ����
		    obj.totalAmount.setValue(rc.get("tBPCADAmount"));//����
		    obj.FirstAmount.setValue(rc.get("tBPCADFirstAmount"));//������
		    obj.drugUnit.setValue(rc.get("tBPCADUomDr"));//��λ
		    obj.drugDosage.setValue(rc.get("tBPCADDose"));//����
		    obj.drugConcentration.setValue(rc.get("tBPCADConcentration"));//Ũ��
		    obj.drugFrequency.setValue(rc.get("tBPCADFrequency"));//Ƶ��
		    obj.note.setValue(rc.get("tBPCADNote"));//��ע
		    obj.ctlocdesc.setValue(rc.get("tBPCDeptId"))
		    obj.ctlocdesc.setRawValue(rc.get("tBPCDept"))  //����
		    var bpcAMIdList=rc.get("tBPCAMIdList");
		    var bpcAMIdListArray=bpcAMIdList.split(",");
		    var bpcAMDescList=rc.get("tBPCAMDescList")
		    var bpcAMDescListArray=bpcAMDescList.split(",");
		    var setCombValue="";
			for(var i=0;i<bpcAMIdListArray.length;i++){
				if(setCombValue==""){
					setCombValue=bpcAMIdListArray[i]+"!"+bpcAMDescListArray[i];
				}else{
						setCombValue=setCombValue+","+bpcAMIdListArray[i]+"!"+bpcAMDescListArray[i];
				}
			}
		    obj.AnticoagulantMode.setDefaultValue(setCombValue); //������ʽ
		 	preRowID=SelectedRowID;
		}else{
			obj.Rowid.setValue("")
		    obj.drugCode.setValue("");//ҩƷCode
		    obj.drugName.setValue(""); //ҩƷ����
		    obj.totalAmount.setValue("");//����
		    obj.FirstAmount.setValue("");//������
		    obj.drugUnit.setValue("");//��λ
		    obj.drugDosage.setValue("");//����
		    obj.drugConcentration.setValue("");//Ũ��
		    obj.drugFrequency.setValue("");//Ƶ��
		    obj.note.setValue("");//��ע
		    obj.AnticoagulantMode.setValue("")//������ʽ
		    obj.ctlocdesc.setValue("") //����
			SelectedRowID = 0;
		    preRowID=0;
		};
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.drugCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҩƷ���벻��Ϊ��!");	
			return;
		}
		if(obj.drugName.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҩƷ������Ϊ��!");	
			return;
		}
		
		var BPCADCode=obj.drugCode.getValue();//ҩƷCode
		var BPCADDesc=obj.drugName.getValue(); //ҩƷ����
		var BPCADAmount=obj.totalAmount.getValue();//����
		var BPCADFirstAmount=obj.FirstAmount.getValue();//������
		var BPCADUomDr=obj.drugUnit.getValue();//��λ
		var BPCADDose=obj.drugDosage.getValue();//����
		var BPCADConcentration=obj.drugConcentration.getValue();//Ũ��
		var BPCADFrequency=obj.drugFrequency.getValue();//Ƶ��
		var BPCADNote=obj.note.getValue();//��ע
		var bpcAMIdList=obj.AnticoagulantMode.getValue()//������ʽ
		var bpclocId=obj.ctlocdesc.getValue(); //����
		var bpcADInfoList=BPCADCode+"^"+BPCADDesc+"^"+BPCADAmount+"^"+BPCADConcentration+"^"+BPCADUomDr+"^"+BPCADFirstAmount+"^"+BPCADDose+"^"+BPCADFrequency+"^"+BPCADNote+"^"+bpcAMIdList+"^"+bpclocId
		//alert(bpcADInfoList);return
		var ret=_DHCBPCAnticoagulantDrug.InsertAnticoagulantDrug(bpcADInfoList);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//ҩƷCode
		    obj.drugName.setValue(""); //ҩƷ����
		    obj.totalAmount.setValue("");//����
		    obj.FirstAmount.setValue("");//������
		    obj.drugUnit.setValue("");//��λ
		    obj.drugDosage.setValue("");//����
		    obj.drugConcentration.setValue("");//Ũ��
		    obj.drugFrequency.setValue("");//Ƶ��
		    obj.note.setValue("");//��ע
		    obj.AnticoagulantMode.setValue("")//������ʽ
		    obj.ctlocdesc.setValue("")//����
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("��ʾ","ID����Ϊ��!");	
			return;
		}		
		if(obj.drugCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҩƷ���벻��Ϊ��!");	
			return;
		}
		if(obj.drugName.getValue()=="")
		{
			ExtTool.alert("��ʾ","ҩƷ������Ϊ��!");	
			return;
		}
		var Rowid=obj.Rowid.getValue();
		var BPCADCode=obj.drugCode.getValue();//ҩƷCode
		var BPCADDesc=obj.drugName.getValue(); //ҩƷ����
		var BPCADAmount=obj.totalAmount.getValue();//����
		var BPCADFirstAmount=obj.FirstAmount.getValue();//������
		var BPCADUomDr=obj.drugUnit.getValue();//��λ
		var BPCADDose=obj.drugDosage.getValue();//����
		var BPCADConcentration=obj.drugConcentration.getValue();//Ũ��
		var BPCADFrequency=obj.drugFrequency.getValue();//Ƶ��
		var BPCADNote=obj.note.getValue();//��ע
		var bpcAMIdList=obj.AnticoagulantMode.getValue()//������ʽ
		var bpclocId=obj.ctlocdesc.getValue(); //����
		var bpcADInfoList=Rowid+"^"+BPCADCode+"^"+BPCADDesc+"^"+BPCADAmount+"^"+BPCADConcentration+"^"+BPCADUomDr+"^"+BPCADFirstAmount+"^"+BPCADDose+"^"+BPCADFrequency+"^"+BPCADNote+"^"+bpcAMIdList+"^"+bpclocId
		//alert(bpcADInfoList)
       
		var ret=_DHCBPCAnticoagulantDrug.UpdateAnticoagulantDrug(bpcADInfoList);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//ҩƷCode
		    obj.drugName.setValue(""); //ҩƷ����
		    obj.totalAmount.setValue("");//����
		    obj.FirstAmount.setValue("");//������
		    obj.drugUnit.setValue("");//��λ
		    obj.drugDosage.setValue("");//����
		    obj.drugConcentration.setValue("");//Ũ��
		    obj.drugFrequency.setValue("");//Ƶ��
		    obj.note.setValue("");//��ע
		    obj.AnticoagulantMode.setValue("")//������ʽ
		    obj.ctlocdesc.setValue("")//����
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCAnticoagulantDrug.DeleteAnticoagulantDrug(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	//obj.Rowid.setValue("");
		    obj.drugCode.setValue("");//ҩƷCode
		    obj.drugName.setValue(""); //ҩƷ����
		    obj.totalAmount.setValue("");//����
		    obj.FirstAmount.setValue("");//������
		    obj.drugUnit.setValue("");//��λ
		    obj.drugDosage.setValue("");//����
		    obj.drugConcentration.setValue("");//Ũ��
		    obj.drugFrequency.setValue("");//Ƶ��
		    obj.note.setValue("");//��ע
		    obj.AnticoagulantMode.setValue("")//������ʽ
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}