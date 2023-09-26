//获取最大码 inci_code
var MaxCodeUrl=DictUrl+'druginfomaintainaction.csp';
function GetMaxCode(Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 药品类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'类组',
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
		
	// 库存分类
	var StkCat = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
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
		fieldLabel:'最大码',
		disabled:true,
		modal :true,
		frame:true,
		anchor:'90%'
	});
	//按照代码开头几位查询
	var FirCode = new Ext.form.TextField({
		id:'FirCode',
		name:'FirCode',
		fieldLabel:'代码(开头几位)',
		modal :true,
		frame:true,
		anchor:'90%'
	});
	
	var SearchMaxCode = new Ext.Button({
		id:'SearchMaxCode',
		name:'SearchMaxCode',
		iconCls:'page_find',
		text:'查找',
		handler:function(){
			var Cat = Ext.getCmp("StkCat").getValue();
			var FirCode = Ext.getCmp("FirCode").getValue();
			
			if((Cat==null || Cat=="")&&(FirCode==null || FirCode=="")){
				Msg.info("warning","请选择库存分类或最大码开头!");
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
		text:'确定',
		handler:function(){
			var newMaxCode="";	//新的最大码
			var MaxCode=Ext.getCmp("MaxCode").getValue();
			if(MaxCode==""){
				Msg.info("warning","未查询到最大码,请自行维护!");
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
			//生成新的最大码
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
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		iconCls:'page_clearscreen',
		tooltip : '点击清空',
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
		title : '获取最大码',
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