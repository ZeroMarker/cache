//��ȡ����� inci_code
var MaxCodeUrl=DictUrl+'druginfomaintainaction.csp';
function GetMaxCode(Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'����',
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,
		UserId:userId,
		LocId:gLocId,
		anchor : '90%'
	}); 
	
	StkGrpType.on('change',function(){
		Ext.getCmp("StkCat").setValue('');
		Ext.getCmp("MaxCode").setValue('');
	});
		
	// ������
	var StkCat = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'StkCat',
		name : 'StkCat',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	
	
	var MaxCode = new Ext.form.TextField({
		id:'MaxCode',
		name:'MaxCode',
		fieldLabel:'�����',
		disabled:true,
		modal :true,
		frame:true,
		anchor:'90%'
	});
	//���մ��뿪ͷ��λ��ѯ
	var FirCode = new Ext.form.TextField({
		id:'FirCode',
		name:'FirCode',
		fieldLabel:'����(��ͷ��λ)',
		modal :true,
		frame:true,
		anchor:'90%'
	});
	
	var SearchMaxCode = new Ext.Button({
		id:'SearchMaxCode',
		name:'SearchMaxCode',
		iconCls:'page_find',
		text:'����',
		handler:function(){
			var Cat = Ext.getCmp("StkCat").getValue();
			var FirCode = Ext.getCmp("FirCode").getValue();
			
			if((Cat==null || Cat=="")&&(FirCode==null || FirCode=="")){
				Msg.info("warning","��ѡ������������뿪ͷ!");
				return;
			}
			var Cat=Cat+"^"+FirCode
			var url = MaxCodeUrl + "?actiontype=GetMaxCodeByCat&Cat="+Cat;
			var result=ExecuteDBSynAccess(url);
			var maxCode=Ext.util.JSON.decode(result).info;
			Ext.getCmp("MaxCode").setValue(maxCode);
		}
	});
	
	var SetMaxCode = new Ext.Button({
		id:'SetMaxCode',
		name:'SetMaxCode',
		iconCls:'page_save',
		text:'ȷ��',
		handler:function(){
			var newMaxCode="";	//�µ������
			var MaxCode=Ext.getCmp("MaxCode").getValue();
			if(MaxCode==""){
				Msg.info("warning","δ��ѯ�������,������ά��!");
				maxCodeWin.close();
				return;
			}
			var codeLen=MaxCode.length;
			for(var index=0;index<codeLen;index++){
				var subCodeStr=MaxCode.slice(index);
				var num=Number(subCodeStr);
				if(isFinite(num)){
					break;
				}
			}
			//�����µ������
			if(index==codeLen){
				newMaxCode=MaxCode+"1";
			}else if(index==0){
				newMaxCode=String.leftPad((num+1).toString(),codeLen,'0');
			}else{
				var numLen=codeLen-index;
				var rightStr=MaxCode.slice(0,index);
				var newLeftCode=String.leftPad((num+1).toString(),numLen,'0');
				newMaxCode=rightStr+newLeftCode;
			}
			Fn(newMaxCode);
			maxCodeWin.close();
		}
	});
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		iconCls:'page_clearscreen',
		tooltip : '������',
		width : 78,
		height : 20,
		handler : function() {
			Ext.getCmp("StkCat").setValue("");
			Ext.getCmp("FirCode").setValue("");
			Ext.getCmp("MaxCode").setValue("");
		}
	});
	var panel = new Ext.form.FormPanel({
		id:'panel',
		region:'center',
		layout:'form',
		labelWidth:60,
		frame:true,
		labelAlign:'right',
		bodyStyle:'padding:10px;',
		items:[StkGrpType,StkCat,FirCode,MaxCode]
	});
	
	var maxCodeWin = new Ext.Window({
		title : '��ȡ�����',
		width :350,
		height : 250,
		modal:true,
		layout : 'border',
		bodyStyle:'padding:10px;',
		items : [panel],
		buttons:[SearchMaxCode,SetMaxCode,ClearBT],
		buttonAlign : 'center'
	});
	
	maxCodeWin.show();
}