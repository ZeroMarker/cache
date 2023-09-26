//获取最大码 inci_code
var MaxCodeUrl=DictUrl+'druginfomaintainaction.csp';

function GetMaxCode(Fn){
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];
	
	if (Ext.getCmp('maxCodeWin'))  //若窗口已存在,则显示即可
	{
		Ext.getCmp('maxCodeWin').show();
		return;
	}
	
	// 类组
	var MaxCodeStkGrpType = new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'类组',
		id : 'MaxCodeStkGrpType',
		StkType:App_StkTypeCode,
		UserId:gUserId,
		LocId:gLocId,
		anchor:'90%',
		childCombo : 'MaxCodeStkCat'
	});
	
	function InitMaxCodeInfo(){
		var ScgId = Ext.getCmp('StkGrpType').getValue();
		var ScgDesc = Ext.getCmp('StkGrpType').getRawValue();
		var Incsc = Ext.getCmp('StkCat').getValue();
		var IncscDesc = Ext.getCmp('StkCat').getRawValue();
		if(ScgId != '' && ScgDesc != ''){
			addComboData(MaxCodeStkGrpType.getStore(), ScgId, ScgDesc,MaxCodeStkGrpType);
			Ext.getCmp('MaxCodeStkGrpType').setValue(ScgId,ScgDesc);
			if(Incsc != '' && IncscDesc != ''){
				addComboData(StkCatStore, Incsc, IncscDesc);
				Ext.getCmp('MaxCodeStkCat').setValue(Incsc);
				SearchMaxCode.handler();
			}
		}
	}
	
	// 库存分类
	var MaxCodeStkCat = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'MaxCodeStkCat',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'MaxCodeStkGrpType'},
		listeners : {
			select : function(index){
				SearchMaxCode.handler();
			}
		}
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
		fieldLabel:'代码前缀',
		modal :true,
		frame:true,
		anchor:'90%',
		listeners : {
			specialkey : function(field, e){
				if(e.getKey() == e.ENTER){
					SearchMaxCode.handler();
				}
			}
		}
	});
	var SearchMaxCode = new Ext.Button({
		id:'SearchMaxCode',
		name:'SearchMaxCode',
		text:'查找',
		iconCls : 'page_find',
		height: 30,
		width: 70,
		handler:function(){
			var Cat = Ext.getCmp("MaxCodeStkCat").getValue();
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
		text:'确定',
		iconCls: 'page_save',
		height: 30,
		width: 70,
		handler:function(){
			var newMaxCode="";	//新的最大码
			var MaxCode=Ext.getCmp("MaxCode").getValue();
			var Scg = Ext.getCmp('MaxCodeStkGrpType').getValue();
			var Cat = Ext.getCmp("MaxCodeStkCat").getValue();
			var ScgDesc = Ext.getCmp('MaxCodeStkGrpType').getRawValue();
			if(MaxCode==""){
				Msg.info("warning","未查询到最大码,请自行维护!");
				maxCodeWin.close();
				return;
			}
			var codeLen=MaxCode.length;
			for(var index=0;index<codeLen;index++){
				var subCodeStr=MaxCode.slice(index);
				var num=Number(subCodeStr);
				if(isFinite(num) && Number(num) > 0){
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
			
//			newMaxCode = tkMakeServerCall('web.DHCSTM.Tools.CodeInput','createCode',Scg,Cat)
			maxCodeWin.close();
			Fn(newMaxCode,Cat,Scg,ScgDesc);
		}
	});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		height: 30,
		width: 70,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearAllEdits();
		}
	});
	
	var byCat = new Ext.form.Radio({
		name:'dispMode',
		boxLabel:'按分类',
		anchor:'90%',
		inputValue:0
	});
	function clearAllEdits()
	{
		Ext.getCmp('MaxCodeStkGrpType').setValue('');
		Ext.getCmp('MaxCodeStkCat').setValue('');
		Ext.getCmp('FirCode').setValue('');
		Ext.getCmp('MaxCode').setValue('');
	}
	var byPrefix = new Ext.form.Radio({
		name:'dispMode',
		boxLabel:'按代码前缀(开头几位)',
		anchor:'90%',
		inputValue:1
	});

	var createMaxCode = new Ext.form.RadioGroup({
		fieldLabel:'获取方式',
		items:[byCat,byPrefix],
		listeners:{
			'change':function(grp,radio){
				if(radio==byPrefix){
					clearAllEdits();
					Ext.getCmp('MaxCodeStkCat').setDisabled(true);
					Ext.getCmp('MaxCodeStkGrpType').setDisabled(true);
					Ext.getCmp('FirCode').setDisabled(false);
					Ext.getCmp('FirCode').focus(false,200);
				}else if(radio==byCat){
					clearAllEdits();
					Ext.getCmp('FirCode').setDisabled(true);
					Ext.getCmp('MaxCodeStkCat').setDisabled(false);
					Ext.getCmp('MaxCodeStkGrpType').setDisabled(false);
					InitMaxCodeInfo();		//按当前物资维护界面的显示值进行缺省设置
					Ext.getCmp('MaxCodeStkGrpType').focus(false,200);
				}
			}
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
		items:[createMaxCode,MaxCodeStkGrpType,MaxCodeStkCat,FirCode,MaxCode]
	});
	
	var maxCodeWin = new Ext.Window({
		title : '获取最大码',
		id:'maxCodeWin',
		width :480,
		minWidth:400,
		height : 250,
		modal:true,
		layout : 'border',
		bodyStyle:'padding:10px;',
		items : [panel],
		buttons:[SearchMaxCode,SetMaxCode,ClearBT],
		buttonAlign : 'center',
		closeAction:'hide',  //关闭模式是hide
		listeners : {
			'show' : function(win){
				if (byCat.getValue()) {
					Ext.getCmp('MaxCodeStkGrpType').focus(false,500);					
				}
				else
				{Ext.getCmp('FirCode').focus(false,500);}
			},
			'afterrender':function(){
				byCat.setValue(true);
			}
		}
	});
	
	maxCodeWin.show();
}