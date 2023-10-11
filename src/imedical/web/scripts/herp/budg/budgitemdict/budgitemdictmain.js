var	hospid = session['LOGON.HOSPID'];
var mainUrl = 'herp.budg.budgitemdictexe.csp';
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var tmpNode = "";
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	
		var tmpRowid = "";
		var tmpLeaf = "";
		var tmpCode = "";
		var tmpLevel = 1;
		var tmpYear = "";
		var tmpCompDR="";
		var tmpTypeCode="";
		var tmpCalUnit="";
		//alert(tmpNode);
		if (tmpNode!="") {
			tmpRowid = tmpNode.attributes["Rowid"];
			tmpYear = tmpNode.attributes["Year"];
			tmpLeaf =  tmpNode.attributes["leaf"];
			tmpCode = tmpNode.attributes["Code"];
			tmpLevel = parseInt(tmpNode.attributes["Level"])+1;
			tmpCompDR = tmpNode.attributes["CompDR"];
			tmpTypeCode = tmpNode.attributes["TypeCode"];
			tmpCalUnit = tmpNode.attributes["CalUnit"];
		}
		
		
		if(tmpLeaf){
			
			Ext.Msg.show({title:'错误',msg:'末级不能添加子节点!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
			
			
			var AddCompDRDs = new Ext.data.Store({
						
						url : commonboxURL+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});


			var AddCompDRCombo = new Ext.form.ComboBox({
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						anchor: '95%',
						selectOnFocus : true
					});	
					
			AddCompDRDs.on("load", function(){
	
				var Num=AddCompDRDs.getCount();
			    if (Num!=0){
			        var id=AddCompDRDs.getAt(0).get('rowid');
				    AddCompDRCombo.setValue(id); 
			    } 

			});
			
			// ////////////////////////////////////
			var smYearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['year', 'year'])
					});

			smYearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
									url : commonboxURL+'?action=year&flag=',
									method : 'POST'
								});
					});

			var YearField = new Ext.form.ComboBox({
						fieldLabel : '年度',
						store : smYearDs,
						disabled : true,
						displayField : 'year',
						valueField : 'year',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						value:tmpYear,
						anchor: '95%',
						selectOnFocus : true
					});
			if(tmpNode==""){
				YearField.enable();
				}
		
			var CodeField = new Ext.form.TextField({
				fieldLabel: '编码',
				width:180,
				allowBlank:false,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '名称',
				width:180,
				allowBlank:false,
				anchor: '95%',
				selectOnFocus:'true'
			});
	
			var NameAllField = new Ext.form.TextField({
				fieldLabel: '全称',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});							
			
			//1会计科目
			//2医疗指标
			var TypeCodeFirstField = new Ext.form.ComboBox({												
				fieldLabel: '大类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '会计科目'], ['2', '医疗指标']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			
			////////////////////////////////////////////////////////
			var bonusTargetTypeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['code', 'name'])
			});

			bonusTargetTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=itemtype&flag=1',
							method : 'POST'
						})
			});

			var TypeCodeField = new Ext.form.ComboBox({
				fieldLabel : '科目类别',
				width : 70,
				listWidth : 245,
				allowBlank : true,
				store : bonusTargetTypeDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				name:'tmpTypeCode',
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			//////////////////////////////////////////////////////////
			
			var SpellField = new Ext.form.TextField({												
				fieldLabel: '拼音码',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var DirectionField = new Ext.form.ComboBox({												
				fieldLabel: '方向',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['0', '借方'], ['1', '贷方']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			var IsLastField = new Ext.form.Checkbox({												
				fieldLabel: '末级'
			});
			
			var IsSpecialField = new Ext.form.Checkbox({												
				fieldLabel: '专项标记'
			});
			
			//M 药品
			//T 医疗
			var SubjClassMTField = new Ext.form.ComboBox({												
				fieldLabel: '医药科目类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '药品'], ['2', '医疗']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
	
			//1：人员
			//2：材料
			//3：净药品
			//4：设备
			//5：后勤
			//6：其他
			var SubjClassPayField = new Ext.form.ComboBox({												
				fieldLabel: '支出科目类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '人员'], ['2', '材料'], ['3', '净药品'],['4', '设备'], ['5', '后勤'], ['6', '其他']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			var IsCashField = new Ext.form.Checkbox({												
				fieldLabel: '现金标志'
			});
			
			//1:固定成本
			//2:变动成本
			var SubjClassCostTypeField = new Ext.form.ComboBox({												
				fieldLabel: '成本类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '固定成本'], ['2', '变动成本']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			//1:收支预算
			//2:工作量指标预算
			//3.项目预算
			var UseRangeField = new Ext.form.ComboBox({												
				fieldLabel: '适用范围',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '收支预算'], ['2', '指标预算'], ['3', '项目预算']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});		
			
			UseRangeField.on('select',function(combo,record, index){
				var rcs=combo.getValue();
				if(rcs=="3"){
					deptnameField.enable();
				}else{
					deptnameField.setValue("");
					deptnameField.disable();
				}
			});
			//1: 指令性指标
			//2: 指导指标
			//3: 政策性指标
			//4: 一般
			var IdxTypeField = new Ext.form.ComboBox({												
				fieldLabel: '指标类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '指令性指标'], ['2', '指导指标'], ['3', '政策性指标'], ['4', '一般'],['5', '工作量指标'], ['6', '社会效益指标'], ['7', '经济效益指标']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});		
			
			//1：自上而下
			//2：自下而上
			//3：上下结合
			var EditModField = new Ext.form.ComboBox({												
				fieldLabel: '编制模式',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '自上而下'], ['2', '自下而上'], ['3', '上下结合']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			
			//1: 零基预算
			//2：弹性预算
			//3：固定预算
			var EditMethField = new Ext.form.ComboBox({												
				fieldLabel: '编制方式',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '零基预算'], ['2', '弹性预算'], ['3', '固定预算']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});							
			
			var IsCarryField = new Ext.form.Checkbox({												
				fieldLabel: '结转'
			});					
			
			//1：状态值
			//2：可累加
			var ProperyTypeField = new Ext.form.ComboBox({												
				fieldLabel: '数据类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '状态值'], ['2', '可累加']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});		
			
			
			////////////////////////////////////////////////////////
			var CalUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

			CalUnitDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=calunit',
							method : 'POST'
						})
			});

			var CalUnitField = new Ext.form.ComboBox({
				fieldLabel : '计量单位',
				width : 70,
				listWidth :245,
				allowBlank : true,
				store : CalUnitDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				name:tmpCalUnit,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
								
			
			var IsCalcField = new Ext.form.Checkbox({												
				fieldLabel: '是否计算'
			});						
			
			IsCalcField.on('check', function( c , checked ){
				if(checked){
					FormulaField.enable();
					FormulaDescField.enable();
				}else{
					FormulaField.setValue("");
					FormulaField.disable();
					FormulaDescField.setValue("");
					FormulaDescField.disable();
				}
			});

			var FormulaField = new Ext.form.TextField({												
				fieldLabel: '计算公式',
				editable : false,
				disabled: true,
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});	
			
			var FormulaDescField = new Ext.form.TextField({												
				fieldLabel: '公式描述',
				width:180,
				disabled: true,
				anchor: '95%',
				selectOnFocus:'true'
			});			

			FormulaDescField.on('focus', function(f){
				var year=YearField.getValue();
				budgformula(1, year, FormulaDescField);
			});			
			
			var IsResultField = new Ext.form.Checkbox({												
				fieldLabel: '最终预算项'
			});		
			
			var IsNewField = new Ext.form.Checkbox({												
				fieldLabel: '是否新'
			});
			
	//获取责任科室名称
	var deptnameDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
	
	deptnameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url: commonboxURL+'?action=dept&flag=3&str='+encodeURIComponent(Ext.getCmp('deptnameField').getRawValue()),method:'POST'});
	});
	
	var deptnameField = new Ext.form.ComboBox({
		id: 'deptnameField',
		fieldLabel: '责任科室',
		width:70,
		listWidth : 245,
		//allowBlank: false,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		anchor: '95%',
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
			
			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									AddCompDRCombo,				
									YearField,				
									CodeField,				
									NameField,				
									NameAllField,	
									SpellField,				
									IsCarryField,
									IsCashField,										
									IsLastField,				
									IsSpecialField,	
									IsResultField,
									IsCalcField,
									IsNewField
									
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [	
									TypeCodeField,				
									DirectionField,	
									TypeCodeFirstField,		
									SubjClassMTField,
									SubjClassPayField,
									SubjClassCostTypeField,	
									UseRangeField,			
									IdxTypeField,				
									EditModField,				
									EditMethField,			
									ProperyTypeField,		
									//FormulaField,				
									FormulaDescField,
									CalUnitField,
									deptnameField		
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'添加'
			});

			addHandler = function(){
			
				var CompDR				= AddCompDRCombo.getValue();
				var Year				= YearField.getValue();
				if(Year=="")
				{
				Ext.Msg.show({title:'注意',msg:'年度不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
				}
				var Code				= CodeField.getValue();	
				var Name				= NameField.getValue();
				var NameAll				= NameAllField.getValue();
				var TypeCodeFirst		= TypeCodeFirstField.getValue();
				var TypeCode			= TypeCodeField.getValue();
				var Spell				= SpellField.getValue();
				var Direction			= DirectionField.getValue();
				var IsLast				= IsLastField.getValue();
				if(IsLast){
					IsLast = 1
				}else{
					IsLast = 0
				}
				var IsSpecial			= IsSpecialField.getValue();
				if(IsSpecial){
					IsSpecial = 1
				}else{
					IsSpecial = 0
				}
				var SubjClassMT			= SubjClassMTField.getValue();
				var SubjClassPay		= SubjClassPayField.getValue();
				var IsCash				= IsCashField.getValue();
				if(IsCash){
					IsCash = 1
				}else{
					IsCash = 0
				}
				var SubjClassCostType	= SubjClassCostTypeField.getValue();
				var UseRange			= UseRangeField.getValue();
				var IdxType				= IdxTypeField.getValue();
				var EditMod				= EditModField.getValue();
				var EditMeth			= EditMethField.getValue();
				var IsCarry				= IsCarryField.getValue();
				var CalUnit				= CalUnitField.getValue();
				if(IsCarry){
					IsCarry = 1
				}else{
					IsCarry = 0
				}
				var ProperyType			= ProperyTypeField.getValue();
				var IsCalc				= IsCalcField.getValue();
				if(IsCalc){
					IsCalc = 1
				}else{
					IsCalc = 0
				}
				var Formula="";
				var Formula				= FormulaDescField.getValue().split("=")[1];
				var FormulaDesc			= FormulaDescField.getValue().split("=")[0];
				if((IsCalc==1)&&(FormulaDesc==""))
				{
				Ext.Msg.show({title:'注意',msg:'公式描述不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
				}
				var IsResult			= IsResultField.getValue();
				if(IsResult){
					IsResult = 1
				}else{
					IsResult = 0
				}
				var IsNew				= IsNewField.getValue();
				if(IsNew){
					IsNew = "新"
				}else{
					IsNew = "旧"
				}
				var ProjDuTYD			= deptnameField.getValue();		
				if(UseRangeField=="3"){
					if(ProjDuTYD==""){
						Ext.Msg.show({title:'注意',msg:'请选择项目责任科室!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						return;
						}
					}
						
				
				var data = CompDR+"|"+Year+"|"+Code+"|"+tmpCode+"|"+Name+"|"+NameAll+"|"+tmpLevel+"|"+TypeCodeFirst+"|"+TypeCode+"|"+Spell+"|"+Direction+"|"+IsLast+"|"+IsSpecial+"|"+SubjClassMT+"|"+SubjClassPay+"|"+IsCash+"|"+SubjClassCostType+"|"+UseRange+"|"+IdxType+"|"+EditMod+"|"+EditMeth+"|"+IsCarry+"|"+ProperyType+"|"+IsCalc+"|"+Formula+"|"+FormulaDesc+"|"+IsResult+"|"+CalUnit+"|"+IsNew+"|"+ProjDuTYD
							
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: mainUrl+'?action=add&data='+encodeURIComponent(data),
						waitMsg:'保存中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								//alert(tmpNode);
								if(tmpNode==""){
								mainGrid.root.reload();
								}
								else
								{if (tmpLevel==2)
									{
										//var tmpPar=tmpNode.parentNode;
										mainGrid.root.reload();	
									}else
									{
										mainGrid.loader.load(tmpNode);
										//tmpNode.expand(true);
									}
								}
								
								tmpNode = "";
								addwin.close();
								//mainGrid.root.reload();
							}else{
								var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '添加预算项',
				width: 500,
				height: 480,
				//autoHeight: true,
				atLoad: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					addButton,
					cancelButton
				]
			});
		
			addwin.show();
			
		}
	
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'option',
	handler:function(){

		tmpNode=""
		tmpNode=mainGrid.getSelectionModel().getSelectedNode();
		//alert(tmpNode)
		if((tmpNode=="")||(tmpNode==null)){
			Ext.Msg.show({title:'错误',msg:'没有选择节点!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
		
			var tmpRowid				= tmpNode.attributes["Rowid"];				
			var tmpCompDR				= tmpNode.attributes["CompDR"];	
			var tmpCompName				= tmpNode.attributes["CompName"];				
			var tmpYear					= tmpNode.attributes["Year"];				
			var tmpCode					= tmpNode.attributes["Code"];				
			var tmpName					= tmpNode.attributes["Name"];				
			var tmpNameAll				= tmpNode.attributes["NameAll"];				
			var tmpTypeCodeFirst		= tmpNode.attributes["TypeCodeFirst"];		
			var tmpTypeCode				= tmpNode.attributes["TypeCode"];			
			var tmpTypeName				= tmpNode.attributes["TypeName"];			
			var tmpSpell				= tmpNode.attributes["Spell"];				
			var tmpDirection			= tmpNode.attributes["Direction"];
			var tmpCalUnitDR			= tmpNode.attributes["CalUnitDR"];			
			var tmpCalUnit				= tmpNode.attributes["CalUnit"];			
			var tmpIsLast				= tmpNode.attributes["IsLast"];	
			var tmpLevel				= tmpNode.attributes["Level"];
			//alert(tmpLevel)		
			if(tmpIsLast==1){
				tmpIsLast = true
			}else{
				tmpIsLast = false
			}			
			var tmpIsSpecial			= tmpNode.attributes["IsSpecial"];	
			if(tmpIsSpecial==1){
				tmpIsSpecial = true
			}else{
				tmpIsSpecial = false
			}				
			var tmpSubjClassMT			= tmpNode.attributes["SubjClassMT"];			
			var tmpSubjClassPay			= tmpNode.attributes["SubjClassPay"];		
			var tmpIsCash				= tmpNode.attributes["IsCash"];		
			if(tmpIsCash==1){
				tmpIsCash = true
			}else{
				tmpIsCash = false
			}				
			var tmpSubjClassCostType	= tmpNode.attributes["SubjClassCostType"];	
			var tmpUseRange				= tmpNode.attributes["UseRange"];			
			var tmpIdxType				= tmpNode.attributes["IdxType"];				
			var tmpEditMod				= tmpNode.attributes["EditMod"];				
			var tmpEditMeth				= tmpNode.attributes["EditMeth"];			
			var tmpIsCarry				= tmpNode.attributes["IsCarry"];		
			if(tmpIsCarry==1){
				tmpIsCarry = true
			}else{
				tmpIsCarry = false
			}				
			var tmpProperyType			= tmpNode.attributes["ProperyType"];			
			var tmpIsCalc				= tmpNode.attributes["IsCalc"];		
			if(tmpIsCalc==1){
				tmpIsCalc = true
			}else{
				tmpIsCalc = false
			}				
			var tmpFormula				= tmpNode.attributes["Formula"];				
			var tmpFormulaDesc			= tmpNode.attributes["FormulaDesc"];			
			var tmpIsResult				= tmpNode.attributes["IsResult"];	
			if(tmpIsResult==1){
				tmpIsResult = true
			}else{
				tmpIsResult = false
			}
			var tmpIsNew				= tmpNode.attributes["IsNew"];
			if(tmpIsNew=="新"){
				tmpIsNew = true
			}else{
				tmpIsNew = false
			}				
			var tmpProjDuTYD			= tmpNode.attributes["ProjDuTYD"];
			var tmpProjDuTYDN			= tmpNode.attributes["ProjDuTYDN"];
						
			var EditCompDRDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
					});
			EditCompDRDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
									url : commonboxURL+'?action=hospital&rowid='+hospid,
									method : 'POST'
								});
					});
			var EditCompDRCombo = new Ext.form.ComboBox({
						fieldLabel : '医疗单位',
						store : EditCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText:tmpCompName,   //tmpCompName,
						width : 70,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						anchor: '95%',
						selectOnFocus : true
					});	
			
			// ////////////////////////////////////
			var smYearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['year', 'year'])
					});

			smYearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
									url : commonboxURL+'?action=year&flag=',
									method : 'POST'
								});
					});

			var YearField = new Ext.form.ComboBox({
						fieldLabel : '年度',
						store : smYearDs,
						editable : false,
						disabled: true,
						displayField : 'year',
						valueField : 'year',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 70,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						value:tmpYear,
						anchor: '95%',
						selectOnFocus : true
					});
		//alert(tmpLevel)
		if(tmpLevel==1)
		{
			YearField.enable();
			}
			var CodeField = new Ext.form.TextField({
				fieldLabel: '编码',
				width:180,
				allowBlank:false,
				value:tmpCode,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var NameField = new Ext.form.TextField({
				fieldLabel: '名称',
				width:180,
				allowBlank:false,
				value:tmpName,
				anchor: '95%',
				selectOnFocus:'true'
			});
	
			var NameAllField = new Ext.form.TextField({
				fieldLabel: '全称',
				width:180,
				value:tmpNameAll,
				anchor: '95%',
				selectOnFocus:'true'
			});							
			
			//1会计科目
			//2医疗指标
			var TypeCodeFirstField = new Ext.form.ComboBox({												
				fieldLabel: '大类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '会计科目'], ['2', '医疗指标']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpTypeCodeFirst,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
////////////////////////////////////////////////////////
			var editTypeCodeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['code', 'name'])
			});

			editTypeCodeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=itemtype&flag=1',
							method : 'POST'
						})
			});

			var editTypeCodeCombo = new Ext.form.ComboBox({
				fieldLabel : '科目类别',
				width : 70,
				listWidth : 245,
				allowBlank : true,
				store : editTypeCodeDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText: tmpTypeName,
				minChars : 1,
				name:'editTypeCodeCombo',
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			
						
			var SpellField = new Ext.form.TextField({												
				fieldLabel: '拼音码',
				width:180,
				value:tmpSpell,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
			var DirectionField = new Ext.form.ComboBox({												
				fieldLabel: '方向',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['0', '借方'], ['1', '贷方']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpDirection,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			var IsLastField = new Ext.form.Checkbox({	
				checked : tmpIsLast,
				fieldLabel: '末级'
			});
			
			var IsSpecialField = new Ext.form.Checkbox({		
				checked : tmpIsSpecial,
				fieldLabel: '专项标记'
			});
			
			//M 药品
			//T 医疗
			var SubjClassMTField = new Ext.form.ComboBox({												
				fieldLabel: '医药科目类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '药品'], ['2', '医疗']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpSubjClassMT,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
	
			//1：人员
			//2：材料
			//3：净药品
			//4：设备
			//5：后勤
			//6：其他
			var SubjClassPayField = new Ext.form.ComboBox({												
				fieldLabel: '支出科目类',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '人员'], ['2', '材料'], ['3', '净药品'],['4', '设备'], ['5', '后勤'], ['6', '其他']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpSubjClassPay,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			var IsCashField = new Ext.form.Checkbox({		
				checked : tmpIsCash,
				fieldLabel: '现金标志'
			});
			
			//1:固定成本
			//2:变动成本
			var SubjClassCostTypeField = new Ext.form.ComboBox({												
				fieldLabel: '成本类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '固定成本'], ['2', '变动成本']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpSubjClassCostType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			//1:收支预算
			//2:工作量指标预算
			//3.项目预算
			var UseRangeField = new Ext.form.ComboBox({												
				fieldLabel: '适用范围',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '收支预算'], ['2', '指标预算'], ['3', '项目预算']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpUseRange,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});		
	UseRangeField.on('select',function(combo,record, index){
	var rcs=combo.getValue();
	if(rcs=="3"){
		deptnameField.enable();
	}else{
		deptnameField.setValue("");
		deptnameField.disable();
	}
});
			//1: 指令性指标
			//2: 指导指标
			//3: 政策性指标
			//4: 一般
			var IdxTypeField = new Ext.form.ComboBox({												
				fieldLabel: '指标类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '指令性指标'], ['2', '指导指标'], ['3', '政策性指标'], ['4', '一般'],['5', '工作量指标'], ['6', '社会效益指标'], ['7', '经济效益指标']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpIdxType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});		
			
			//1：自上而下
			//2：自下而上
			//3：上下结合
			var EditModField = new Ext.form.ComboBox({												
				fieldLabel: '编制模式',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '自上而下'], ['2', '自下而上'], ['3', '上下结合']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpEditMod,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			
			//1: 零基预算
			//2：弹性预算
			//3：固定预算
			var EditMethField = new Ext.form.ComboBox({												
				fieldLabel: '编制方式',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '零基预算'], ['2', '弹性预算'], ['3', '固定预算']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpEditMeth,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});							
			
			var IsCarryField = new Ext.form.Checkbox({		
				checked : tmpIsCarry,		
				fieldLabel: '结转'
			});					
			
			//1：状态值
			//2：可累加
			var ProperyTypeField = new Ext.form.ComboBox({												
				fieldLabel: '数据类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '状态值'], ['2', '可累加']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : tmpProperyType,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});							
			
						////////////////////////////////////////////////////////
			var CalUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

			CalUnitDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=calunit',
							method : 'POST'
						})
			});

			var CalUnitField = new Ext.form.ComboBox({
				fieldLabel : '计量单位',
				width : 70,
				listWidth : 245,
				allowBlank : true,
				store : CalUnitDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText:tmpCalUnit,
				minChars : 1,
				name:'tmpCalUnit',
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			
			var IsCalcField = new Ext.form.Checkbox({		
				checked : tmpIsCalc,
				fieldLabel: '是否计算'
			});						
			
			IsCalcField.on('check', function( c , checked ){
				if(checked){
					FormulaField.enable();
					FormulaDescField.enable();
					FormulaDescField.setValue(tmpFormulaDesc+"="+tmpFormula);
				}else{
					FormulaField.setValue("");
					FormulaField.disable();
					FormulaDescField.setValue("");
					FormulaDescField.disable();
				}
			});

			var FormulaField = new Ext.form.TextField({												
				fieldLabel: '计算公式',
				editable : false,
				width:180,
				disabled: true,
				value : tmpFormula,
				anchor: '95%',
				selectOnFocus:'true'
			});	


			var FormulaDescField = new Ext.form.TextField({												
				fieldLabel: '公式描述',
				width:180,
				disabled: !tmpIsCalc,
				value : tmpFormulaDesc+"="+tmpFormula,
				anchor: '95%',
				selectOnFocus:'true'
			});			

			FormulaDescField.on('focus', function(f){
				var year=YearField.getValue();
				budgformula(1, year, FormulaDescField);
			});									
			
			var IsResultField = new Ext.form.Checkbox({		
				checked : tmpIsResult,			
				fieldLabel: '最终预算项'
			});
			
			var IsNewField = new Ext.form.Checkbox({		
				checked : tmpIsNew,			
				fieldLabel: '是否新'
			});
					
			//获取责任科室名称
			var deptnameDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});
	
	
			deptnameDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:commonboxURL+'?action=dept&flag=3',method:'POST'});
			});
	
			var deptnameField = new Ext.form.ComboBox({
				id: 'deptnameField',
				fieldLabel: '责任科室',
				width:70,
				listWidth : 245,
				//allowBlank: false,
				store: deptnameDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'',
				valueNotFoundText:tmpProjDuTYDN,
				name: 'deptnameField',
				minChars: 1,
				pageSize: 10,
				anchor: '95%',
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});	
									
			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									EditCompDRCombo,				
									YearField,				
									CodeField,				
									NameField,				
									NameAllField,	
									SpellField,				
									IsCarryField,
									IsCashField,										
									IsLastField,				
									IsSpecialField,	
									IsResultField,
									IsCalcField,
									IsNewField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [	
									editTypeCodeCombo,				
									DirectionField,	
									TypeCodeFirstField,		
									SubjClassMTField,
									SubjClassPayField,
									SubjClassCostTypeField,	
									UseRangeField,			
									IdxTypeField,				
									EditModField,				
									EditMethField,			
									ProperyTypeField,		
									//FormulaField,				
									FormulaDescField,
									CalUnitField,
									deptnameField		
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 70,
				//layout: 'form',
				frame: true,
				items: colItems
			});
			
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(tmpNode);			
				EditCompDRCombo.setValue(tmpNode.attributes["CompDR"]);
				editTypeCodeCombo.setValue(tmpNode.attributes["TypeCode"]);
				CalUnitField.setValue(tmpNode.attributes["tmpCalUnitDR"]);
				deptnameField.setValue(tmpNode.attributes["tmpProjDuTYD"]);
			});	
	
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			addHandler = function(){
			
				var CompDR				= EditCompDRCombo.getValue();
				var Year				= YearField.getValue();
				if(Year=="")
				{
				Ext.Msg.show({title:'注意',msg:'年度不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
				}
				var Code				= CodeField.getValue();	
				var Name				= NameField.getValue();
				var NameAll				= NameAllField.getValue();
				var TypeCodeFirst		= TypeCodeFirstField.getValue();
				var TypeCode			= editTypeCodeCombo.getValue();
				var Spell				= SpellField.getValue();
				var Direction			= DirectionField.getValue();
				var IsLast				= IsLastField.getValue();
				if(IsLast){
					IsLast = 1
				}else{
					IsLast = 0
				}
				var IsSpecial			= IsSpecialField.getValue();
				if(IsSpecial){
					IsSpecial = 1
				}else{
					IsSpecial = 0
				}
				var SubjClassMT			= SubjClassMTField.getValue();
				var SubjClassPay		= SubjClassPayField.getValue();
				var IsCash				= IsCashField.getValue();
				if(IsCash){
					IsCash = 1
				}else{
					IsCash = 0
				}
				var SubjClassCostType	= SubjClassCostTypeField.getValue();
				var UseRange			= UseRangeField.getValue();
				var IdxType				= IdxTypeField.getValue();
				var EditMod				= EditModField.getValue();
				var EditMeth			= EditMethField.getValue();
				var IsCarry				= IsCarryField.getValue();
				if(IsCarry){
					IsCarry = 1
				}else{
					IsCarry = 0
				}
				var ProperyType			= ProperyTypeField.getValue();
				var CalUnit				= CalUnitField.getValue();
				var IsCalc				= IsCalcField.getValue();
				if(IsCalc){
					IsCalc = 1
				}else{
					IsCalc = 0
				}
				var Formula				= FormulaDescField.getValue().split("=")[1];
				var FormulaDesc			= FormulaDescField.getValue().split("=")[0];				
				if((IsCalc==1)&&(FormulaDesc==""))
				{
				Ext.Msg.show({title:'注意',msg:'公式描述不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
				}
				var IsResult			= IsResultField.getValue();
				if(IsResult){
					IsResult = 1
				}else{
					IsResult = 0
				}
				var IsNew			= IsNewField.getValue();
				if(IsNew){
					IsNew ="新"
				}else{
					IsNew = "旧"
				}
				var ProjDuTYD		= deptnameField.getValue();		
				if(UseRangeField=="3"){
					if(ProjDuTYD==""){
						Ext.Msg.show({title:'注意',msg:'请选择项目责任科室!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						return;
						}
					}																																																																									  
				var data = CompDR+"|"+Year+"|"+Code+"||"+Name+"|"+NameAll+"||"+TypeCodeFirst+"|"+TypeCode+"|"+Spell+"|"+Direction+"|"+IsLast+"|"+IsSpecial+"|"+SubjClassMT+"|"+SubjClassPay+"|"+IsCash+"|"+SubjClassCostType+"|"+UseRange+"|"+IdxType+"|"+EditMod+"|"+EditMeth+"|"+IsCarry+"|"+ProperyType+"|"+IsCalc+"|"+Formula+"|"+FormulaDesc+"|"+IsResult+"|"+CalUnit+"|"+IsNew+"|"+ProjDuTYD
				if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: mainUrl+'?action=edit&rowid='+tmpRowid+'&data='+encodeURIComponent(data),
						waitMsg:'保存中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
								if(IsLast==1){
									if(tmpIsLast==0){
									mainGrid.root.reload();	
									}
									else{
									//alert(tmpNode.parentNode);
									var tmpPar=tmpNode.parentNode;
									
									//mainGrid.loader.load(tmpNode);
									mainGrid.loader.load(tmpPar);
									tmpPar.expand(true);
									}
								}
								else{	
								mainGrid.root.reload();
								}
								tmpNode = "";
								editwin.close();
								
							}else{
								var tmpMsg = jsonData.info;
								if(tmpMsg=="HaveSun"){
									Ext.Msg.show({title:'错误',msg:'含有子项不能修改为"末级"!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}else{
									Ext.Msg.show({title:'错误',msg:tmpMsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
			
			editButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				editwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			editwin = new Ext.Window({
				title: '修改预算项',
				width: 500,
				height: 480,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					editButton,
					cancelButton
				]
			});
		
			editwin.show();

		}
	}
});

var delButton = new Ext.Toolbar.Button
({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function()
	{
		var tmpRowid = "";
		var tmpLeaf = "";
		tmpNode=""
		tmpNode=mainGrid.getSelectionModel().getSelectedNode();
		if ((tmpNode!="")&&(tmpNode!=null)) 
		{

			tmpRowid =   tmpNode.attributes["Rowid"];
			tmpYear =    tmpNode.attributes["Year"];
			tmpLeaf =  tmpNode.attributes["leaf"];
			tmpCode =  tmpNode.attributes["Code"];		
			
			function handler(id)
			{
				if(id=="yes")
				{
					//alert(id);
					Ext.Ajax.request
					({
						url:mainUrl+'?action=del&rowid='+tmpRowid+'&code='+tmpCode+'&year='+tmpYear,
						waitMsg:'删除中...',
						failure: function(result, request)
						{
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request)
						{
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true')
							{
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								//var tmpPar=tmpNode.parentNode;
								tmpNode.remove();
								//alert(tmpNode)
								//alert(tmpPar)
								/****if (!tmpPar)
								{
									mainGrid.root.reload();
									//mainGrid.loader.load(tmpPar);
									alert(1);	
								}
								else
								{
									mainGrid.root.reload();
									alert(2);
								}****/
								tmpNode = "";
								mainGrid.root.reload();
								//tmpNode.expand(false);
								
							}
							else
							{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
				else
				{
					return;
				}
			}
			
			if(tmpLeaf)
			{
				Ext.MessageBox.confirm('提示','确实要删除吗?',handler);
				
			}else
			{
				Ext.MessageBox.confirm('提示','含有子节点,确实要删除吗?',handler);
				
			}
	
		}
		else
		{
			Ext.Msg.show({title:'错误',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});

var expandAllButton = new Ext.Toolbar.Button({
	text: '全部展开',
    tooltip:'全部展开',        
    iconCls:'add',
	handler:function(){
		mainGrid.getRootNode().expand(true);
	}
});

//批量
var CopyButton = new Ext.Toolbar.Button({
	text: '复制',
	tooltip: '往年数据复制到预算年',
	iconCls: 'add',
	handler: function(){
		CopyFun();
	}
});

var mainGrid = new Ext.ux.tree.TreeGrid({
    //title: '预算项字典',
	region: 'center',
    enabled: true,
	autoScroll: true,
    enableSort : false,
    columns:[{
        header: '医疗单位',
        dataIndex: 'CompName',
        width: 150
    },{
        header: '名称',
        dataIndex: 'Name',
        width: 250
    },{
        header: '编码',
        width: 150,
        dataIndex: 'Code'
    },{
        header: '会计年度',
        width: 80,
        dataIndex: 'Year'
    },{
        header: '类别',
        width: 100,
        dataIndex: 'TypeName'
    },{
        header: '级别',
        width: 60,
        dataIndex: 'Level'
    },{
        header: '是否计算',
        width: 60,
        dataIndex: 'IsCalcName'
    },
	//{
   //    header: '计算公式',
   //    width: 150,
   //    dataIndex: 'Formula'
   //},
	{
        header: '公式描述',
        width: 300,
        dataIndex: 'FormulaDesc'
    },
	{
        header: '计量单位',
        width: 100,
        dataIndex: 'CalUnit'
    },
	{
        header: '是否新',
        width: 100,
        dataIndex: 'IsNew'
    },{
        header: '医疗单位ID',
        dataIndex: 'CompDR',
        //hidden:true
        width: 80
    },{
        header: '科目类别编码',
        dataIndex: 'TypeCode',
        //hidden:true
        width: 80
    },{
        header: '计量单位ID',
        dataIndex: 'CalUnitDR',
        //hidden:true
        width: 80
    },{
        header: '责任科室ID',
        dataIndex: 'ProjDuTYD',
        //hidden:true
        width: 80
    }],

    requestUrl: mainUrl+'?action=list',
	
	listeners: {
        'beforeload': function (node) {
        //alert(node.isRoot);
            if (node.isRoot) {
                this.loader.dataUrl = this.requestUrl + "&rnode=";
            }else { 
                var nodeText = node.attributes["Code"];
                var Year = node.attributes["Year"];
                var rqtUrl = this.requestUrl + "&rnode=" + nodeText+"&year="+Year;
                //alert(node.attributes.loader);
                //alert(node.attributes.loader.dataUrl);
                if (node.attributes.loader.dataUrl) {
                    this.loader.dataUrl = rqtUrl
                    //alert(this.loader.dataUrl)
                }
            }
            this.root.attributes.loader = null;
        },
		
		'click' : function( node,  e ) {
			tmpNode = node;
		}
    },
	
	tbar:[addButton,'-',editButton,'-',delButton,'-',expandAllButton,'-',CopyButton]
});