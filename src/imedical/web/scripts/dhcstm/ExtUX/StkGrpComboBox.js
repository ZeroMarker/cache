// /名称: StkGrpComboBox.js
// /描述: 封装类组下拉框
// /编写者：zhangdongmei
// /编写日期: 2012.04.10
Ext.ns('Ext.ux');
/*
Ext.ux.StkGrpComboBox = Ext.extend(Ext.form.ComboBox, { 
	fieldLabel : '类&nbsp;&nbsp;&nbsp;&nbsp;组',
	StkType:null,				//新加属性，标识类组类型
	LocId:null,					//新加属性，科室id
	UserId:null,				//新加属性，人员id
	DrugInfo:"N",				//新加属性，物资信息相关界面,"Y"是物资信息下的菜单,"N"不是物资信息下的菜单
	emptyText : '类组...',                            
	forceSelection : true,
	selectOnFocus : true,
	editable : true,
	allowBlank : true,
	triggerAction : 'all',
	valueField : 'RowId',
	displayField : 'Description',
	minChars : 1,
	valueNotFoundText : '',
	childCombo : "",			//combo的Id组成的array: 关联combo,取值受此combo影响
	scgset:'',	
	initComponent : function() {
		this.childCombo = Ext.isEmpty(this.childCombo)?[]:[].concat(this.childCombo);
		this.createStore();
		Ext.ux.StkGrpComboBox.superclass.initComponent.call(this);
		if(this.triggerAction == 'all') {
			this.doQuery(this.allQuery, true);
		} else {
			this.doQuery(this.getRawValue());
		}
	},
	listeners : {
		select : function(combo,record,index){
			this.onComboSelect(combo,record,index)
		}
	},
	createStore : function(){
		var myUrl="";
		var me=this;
		if(this.LocId==null ||this.LocId==""){
			myUrl=DictUrl+ 'extux.csp?actiontype=StkCatGroup';
		}else{
			myUrl=DictUrl+ 'extux.csp?actiontype=GetLocStkCatGroup';
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'StkGrpStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description','Default'],
			baseParams:{
				type :this.StkType,
				locId:this.LocId,
				userId:this.UserId,
				xLocId:this.xLocId,
				drugInfo:this.DrugInfo,
				scgSet:this.scgset
			},
			listeners : {
				load : function(store,records,opt){
					for(var i=0;i<records.length;i++){
						var record=records[i];
						if(record.get("Default")=="Y" || records.length==1){
							me.setValue(record.get("RowId"));
							me.originalValue=me.getValue();
							break;
						}
					}
				}
			}
		});
	},
	onComboSelect : function(combo,record,index){
		for(var i=0,len=this.childCombo.length;i<len;i++){
			var child = Ext.getCmp(this.childCombo[i]);
			if(!Ext.isEmpty(child) && !child.disabled){
				child.clearValue();
				child.fireEvent('beforequery');
				if(!Ext.isEmpty(child.childCombo)){
					child.fireEvent('select');
				}
			}
		}
	},
	setFilterByLoc:function(LocId,xLocId){
		this.LocId=LocId;
		this.xLocId=xLocId;
		this.store.setBaseParam('type',this.StkType);
		this.store.setBaseParam('locId',this.LocId);
		this.store.setBaseParam('userId',this.UserId);
		this.store.setBaseParam('xLocId',this.xLocId);
		this.setValue('');
		this.store.load();
	}
});
Ext.reg('stkgrpcombo',Ext.ux.StkGrpComboBox);
*/

/**
 * 2016-03-07 add 根据新版多级类组授权取值
 * @class Ext.ux.StkGrpComboBox
 * @extends Ext.form.ComboBox
 */
Ext.ux.StkGrpComboBox = Ext.extend(Ext.ux.TreeCombo, { 
	fieldLabel : '类&nbsp;&nbsp;&nbsp;&nbsp;组',
	url : 'dhcstm.extux.csp?actiontype=GetScgChildNode',
	rootId : 'AllSCG',
	rootParam : 'NodeId',
//	params : {},				//可参考ux.Combo处理,为尽少量的改动代码,沿用以前的封装方式  (这个params暂时不用?否则科室等信息可以放在这里)
	valueParams : {},
	StkType : 'M',				//标识类组类型(G/M/O)
	LocId : '',					//科室id
	UserId : '',				//人员id
	xLocId : '',				//第二科室id, 请求等界面用到
	DrugInfo : 'N',				//物资信息相关界面,"Y"是物资信息下的菜单,"N"不是物资信息下的菜单
	scgset : '',				//类组集合,可以设置为'MM','MO','MR','MF'等几种类型, 也可设置界面空间的id
	emptyText : '类组...',
	editable : true,
	allowBlank : true,
	childCombo : '',			//combo的Id组成的array: 关联combo,取值受此combo影响
	isDefaultValue : true,
	initComponent : function() {
		var _this = this;
		this.childCombo = Ext.isEmpty(this.childCombo)?[]:[].concat(this.childCombo);
		this.CreateValueParams();
		Ext.ux.StkGrpComboBox.superclass.initComponent.call(this);
		this.store.load = function(){
			//1.重写load方法,TreeCombo.store.load会报错
			//2.之前版本类组的store.load在很多js里使用,这里尽量紧贴原有代码设置
			_this.SetDefaultValue();
		};
		this.store.reload = function(){
			//重写reload方法
			_this.CreateValueParams();		//重置参数
			_this.clearValue();
			var RootNode = _this.tree.getRootNode();
			RootNode.removeAll(true);
			if(RootNode.childrenRendered){
				RootNode.reload(_this.SetDefaultValue(), _this);
			}else{
				_this.SetDefaultValue();
			}
		}
		this.SetDefaultValue();
	},
	listeners : {
		select : function(combo,node){
			this.onComboSelect(combo,node);
		}
	},
	CreateValueParams : function(){
		//这里使用this.valueParams必须传值,不能引用,否则有两个实例时会冲突...
		var tmpValues = {};
		for(var param in this.valueParams){
			tmpValues[param] = this.valueParams[param];
		}
		var ScgSet = this.scgset;
		if(!Ext.isEmpty(ScgSet) && ['MM','MO','MR','MF'].indexOf(ScgSet)<0 && Ext.getCmp(ScgSet)){
			//若scgset属性设置,且不在这几种固定类型中,按界面控件取值
			this.scgset = Ext.getCmp(ScgSet).getValue();
		}
		//StrParam参数(科室^人员^第二科室^类组集合^...)
		tmpValues.StrParam = this.LocId + '^' + this.UserId + '^' + this.xLocId + '^' + this.scgset;
		tmpValues.type = this.StkType;
		this.valueParams = tmpValues;
	},
	onComboSelect : function(combo,node){
		for(var i=0,len=this.childCombo.length;i<len;i++){
			var child = Ext.getCmp(this.childCombo[i]);
			if(!Ext.isEmpty(child) && !child.disabled){
				child.clearValue();
				child.getStore().removeAll();
				child.fireEvent('beforequery');
				if(!Ext.isEmpty(child.childCombo)){
					child.fireEvent('select');
				}
			}
		}
	},
	setFilterByLoc : function(LocId,xLocId){
		this.LocId = LocId || '';
		this.xLocId = xLocId || '';
		this.CreateValueParams();		//重置参数
		var StrParam = this.valueParams.StrParam;
		var SCG = this.getValue();
		var IsScgAuthor = tkMakeServerCall('web.DHCSTM.Util.DrugUtil', 'IsScgAuthor', StrParam, App_StkTypeCode, SCG);
		var DefaInfo;
		if((IsScgAuthor == 'Y')&&(this.rendered == true)){
			var ScgDesc = this.getRawValue();
			DefaInfo = SCG + '^' + ScgDesc;
		}
		this.clearValue();
		var RootNode = this.tree.getRootNode();
		RootNode.removeAll(true);
		if(RootNode.childrenRendered){
			RootNode.reload(this.SetDefaultValue(DefaInfo), this);
		}else{
			this.SetDefaultValue(DefaInfo);
		}
	},
	/**
	 * 设置类组Combo缺省值
	 * @param {} DefaScg : ScgId^ScgDesc
	 */
	SetDefaultValue : function(DefaInfo){
		if(!this.isDefaultValue || this.StkType != 'M'){
			return;
		}
		if(Ext.isEmpty(DefaInfo)){
			var StrParam = this.LocId + '^' + this.UserId + '^' + this.xLocId;
			var DefaInfo = tkMakeServerCall('web.DHCSTM.MulStkCatGroup', 'GetDefaScg', StrParam);
		}
		var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
		if(ScgId && ScgDesc){
			this.setValue(ScgId, ScgDesc);
		}
	}
});
Ext.reg('stkgrpcombo',Ext.ux.StkGrpComboBox);

// /名称: StkGrpComboBox.js
// /描述: 库存分类封装维护
// /编写者：zhangxiao
// /编写日期: 2013.12.02
Ext.ux.StkCatComboBox = Ext.extend(Ext.form.ComboBox, { 
	fieldLabel : '库存分类',
	StkType:null,				//新加属性，标识类组类型
	LocId:null,					//新加属性，科室id
	UserId:null,				//新加属性，人员id
	emptyText : '库存分类...',
	forceSelection : true,
	selectOnFocus : true,
	editable : true,
	allowBlank : true,
	triggerAction : 'all',
	valueField : 'RowId',
	minChars : 1,
	valueNotFoundText : '',
	displayField : 'Description',
	filterName:null,
	initComponent : function() {
		var myUrl="";
		if(this.LocId==null ||this.LocId==""){
			myUrl=DictUrl+ 'extux.csp?actiontype=StkCat';
		}else{
			myUrl=DictUrl+ 'extux.csp?actiontype=GetLocStkCat';
		}
		this.store=new Ext.data.JsonStore({
			autoDestroy:true,
			url:myUrl,
			storeId:'StkCatStore',
			idProperty:'RowId',
			root:'rows',
			totalProperty:'results',
			fields:['RowId','Description','Default'],
			baseParams:{
				type :this.StkType,
				locId:this.LocId,
				userId:this.UserId
			}
		});
		this.on('beforequery',function(e){
			this.store.removeAll();    //load之前remove原记录，否则容易出错
			var filter=this.getRawValue();
			if(this.filterName!=""){
				this.store.setBaseParam(this.filterName,filter);				
			}
			this.store.load({params:{start:0,limit:this.pageSize}});
		});
		Ext.ux.StkCatComboBox.superclass.initComponent.call(this);
	}
});
Ext.reg('stkcatcombo',Ext.ux.StkCatComboBox);

// /描述: 多级分类封装维护
// /编写者：tsr
// /编写日期: 2017.07.19
Ext.ux.MatCatComboBox = Ext.extend(Ext.ux.TreeCombo, { 
	fieldLabel : '',
	url : '',
	rootId : '',
	rootParam : '',
	valueParams : {},
	emptyText : '',
	editable : true,
	allowBlank : true,
	childCombo : '',
	initComponent : function() {
		Ext.ux.MatCatComboBox.superclass.initComponent.call(this);
		this.store.load = function(){
			this.setValue("", "");
		};
		this.store.reload = function(){
			this.clearValue();
			var RootNode = this.tree.getRootNode();
			RootNode.removeAll(true);
			if(RootNode.childrenRendered){
				RootNode.reload(this.setValue("", ""), this);
			}else{
				this.setValue("", "");
			}
		};
		this.setValue("", "");
	}
});
Ext.reg('matcatcombo',Ext.ux.MatCatComboBox);