// /名称: 效期报警查询
// /描述: 效期报警查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.13
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID']
	var gLocId=session['LOGON.CTLOCID']
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('科室'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				groupId:gGroupId,
				anchor : '90%',
				width : 140,
				listeners : {
	            'select' : function(e) {
	                 	SetDefaultSCG();
					}
				}
				});
	function SetDefaultSCG()
	{
		 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
         StkGrpType.getStore().removeAll();
         StkGrpType.getStore().setBaseParam("locId",SelLocId)
         StkGrpType.getStore().setBaseParam("userId",gUserId)
         StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
         StkGrpType.getStore().load();
         Ext.getCmp("DHCStkCatGroup").setValue("");
	}
	
	var DateTime = new Ext.ux.DateField({
				fieldLabel : $g('截止效期'),
				id : 'DateTime',
				name : 'DateTime',
				anchor : '90%',
				width : 140,
				value : new Date()
			});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel : $g('类组'),
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,//标识类组类型
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId
		}); 
		
		StkGrpType.on('select',function(){
			Ext.getCmp("DHCStkCatGroup").setValue("");
		});
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : $g('库存分类'),
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					width : 140,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		var ZeroFlag = new Ext.form.Checkbox({
					fieldLabel : $g('包括零批次'),
					id : 'ZeroFlag',
					name : 'ZeroFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel : $g('排除不可用项'),
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});
		var zeroTag=new Ext.form.Label({
			html:'<div class="classYellow" style="color:black;padding-left:0px">'+$g('过期')+'<div>'
		})
		var ZeroMonth = new Ext.form.Checkbox({
			fieldLabel : $g('过期'),
			id : 'ZeroMonth',
			name : 'ZeroMonth',
			ctCls:'classRed',
			checked : false
		});
		var OneMonth = new Ext.form.Checkbox({
			fieldLabel : $g('1月'),
			id : 'OneMonth',
			name : 'OneMonth',
			ctCls:'classBlue',
			checked : false
		});
		var TwoMonth = new Ext.form.Checkbox({
			fieldLabel : $g('2月'),
			id : 'TwoMonth',
			name : 'TwoMonth',
			ctCls:'classYellow',			
			checked : false
		});		
		var ThreeMonth = new Ext.form.Checkbox({
			fieldLabel : $g('3月'),
			id : 'ThreeMonth',
			name : 'ThreeMonth',
			ctCls:'classGrassGreen',			
			checked : false
		});	
		var FourMonth = new Ext.form.Checkbox({
			fieldLabel : $g('4月'),
			id : 'FourMonth',
			name : 'FourMonth',
			ctCls:'classCyan',	
			checked : false
		});	
		var FiveMonth = new Ext.form.Checkbox({
			fieldLabel : $g('5月'),
			id : 'FiveMonth',
			name : 'FiveMonth',
			ctCls:'classOrange',	
			checked : false
		});	
		var SixMonth = new Ext.form.Checkbox({
			fieldLabel : $g('6月'),
			id : 'SixMonth',
			name : 'SixMonth',
			ctCls:'classPink',	
			checked : false
		});	
		var SevenMonth = new Ext.form.Checkbox({
			fieldLabel : $g('7月'),
			id : 'SevenMonth',
			name : 'SevenMonth',
			ctCls:'classPurple',	
			checked : false
		});	
		var EightMonth = new Ext.form.Checkbox({
			fieldLabel : $g('8月'),
			id : 'EightMonth',
			name : 'EightMonth',
			ctCls:'classLightBlue',	
			checked : false
		});	
		var NineMonth = new Ext.form.Checkbox({
			fieldLabel : $g('9月'),
			id : 'NineMonth',
			name : 'NineMonth',
			ctCls:'classLightSeaGreen',	
			checked : false
		});	
		var TenMonth = new Ext.form.Checkbox({
			fieldLabel : $g('10月'),
			id : 'TenMonth',
			name : 'TenMonth',
			ctCls:'classLime',	
			checked : false
		});	
		var ElevenMonth = new Ext.form.Checkbox({
			fieldLabel : $g('11月'),
			id : 'ElevenMonth',
			name : 'ElevenMonth',
			ctCls:'classLightGoldenYellow',	
			checked : false
		});	
		var TwelveMonth = new Ext.form.Checkbox({
			fieldLabel : $g('12月'),
			id : 'TwelveMonth',
			name : 'TwelveMonth',
			ctCls:'classDeepSkyBlue',	
			checked : false
		});	
		var Normal = new Ext.form.Checkbox({
			fieldLabel : $g('正常'),
			id : 'Normal',
			name : 'Normal',
			ctCls:"classWhite",
			checked : false
		});	
		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('另存'),
					tooltip : $g('另存为Excel'),
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);

					}
				});
			var PrintBT = new Ext.Toolbar.Button({
				id : "PrintBT",
				text : $g('打印'),
				width : 70,
				height : 30,
				iconCls : 'page_print',
				handler : function() {
					var rowCount=StockQtyStore.getCount();
					if (rowCount ==0) {
						Msg.info("warning", $g("无可用打印数据!"));
						return;
					}
					var tmpParam = StockQtyStore.lastOptions; 
					if (tmpParam && tmpParam.params) {
							var gStrParam=StockQtyStore.baseParams.Params;  //与界面Grid数据参数保持一致,yunhaibao20160419
							var gStrParamArr=gStrParam.split("^");
							var phaLoc=gStrParamArr[0];
							var date=gStrParamArr[1];
							var RestMon=gStrParamArr[2];
							var ZeroDrug=gStrParamArr[3];
							var DHCStkCatGroup=gStrParamArr[4];
							var UseFlag=gStrParamArr[5];
							var StkGrpRowId=gStrParamArr[6];
							var sort="",dir="";
							if (StockQtyStore.sortInfo){
								sort=StockQtyStore.sortInfo.field;
								dir=StockQtyStore.sortInfo.direction;
							}
							if (sort==undefined){sort=""}
							if (dir==undefined){dir=""}
							var LocDesc=Ext.getCmp("PhaLoc").getRawValue();
							var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;										
							var fileName="DHCST_LocItmExpDate.raq&qPar="+sort+"^"+dir+"&Loc="+phaLoc
							+"&refDate="+date+"&RestMonth="+RestMon+"&ZeroStkFlag="+ZeroDrug+"&INCSC="+DHCStkCatGroup
							+"&IncludeNotUseFlag="+UseFlag+"&StkGrpId="+StkGrpRowId+"&LocDesc="+LocDesc+"&UserName="+session['LOGON.USERNAME']
							+"&HospDesc="+App_LogonHospDesc+"&RQDTFormat="+RQDTFormat;
							DHCCPM_RQPrint(fileName)
					}	
				}
			});
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询'),
					tooltip : $g('点击查询'),
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {

			var gStrParam=getQueryParams();
	        if (gStrParam!=""){StockQtyStore.removeAll();}
	        else{return;}
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam('Params',gStrParam)
			StockQtyStore.load({params:{start:0,limit:pageSize},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert($g("查询错误"),StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
		//yunhaibao20160419,查询打印获取参数统一方法
		function getQueryParams()
		{
			var gStrParam=""
			// 必选条件
			var PhaLocDesc = Ext.getCmp("PhaLoc").getRawValue();
			if (PhaLocDesc ==""||PhaLocDesc == null || PhaLocDesc.length <= 0) {
				Msg.info("warning", $g("科室不能为空！"));
				Ext.getCmp("PhaLoc").focus();
				return gStrParam;
			}
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning",$g("科室不能为空！"));
				Ext.getCmp("PhaLoc").focus();
				return gStrParam;
			}
			var DateTimetmp = Ext.getCmp("DateTime").getValue()
			if (DateTimetmp=="") {
			    Msg.info("warning", $g("日期不能为空！"));
			    Ext.getCmp("DateTime").focus();
			    return gStrParam;
			}
			var date = Ext.getCmp("DateTime").getValue().format(App_StkDateFormat).toString();
			if (date == null || date.length <= 0) {
				Msg.info("warning",$g( "日期不能为空！"));
				Ext.getCmp("DateTime").focus();
				return gStrParam;
			}
			// 可选条件
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var ZeroDrug = (Ext.getCmp("ZeroFlag").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var RestMon=null;			
			if(Ext.getCmp("ZeroMonth").getValue()==true){
				if(RestMon==null){
					RestMon=0;
				}else{
					RestMon=RestMon+','+0;
				}
			}
			if(Ext.getCmp("OneMonth").getValue()==true){
				if(RestMon==null){
					RestMon=1;
				}else{
					RestMon=RestMon+','+1;
				}
			}
			if(Ext.getCmp("TwoMonth").getValue()==true){
				if(RestMon==null){
					RestMon=2;
				}else{
					RestMon=RestMon+','+2;
				}
			}
			if(Ext.getCmp("ThreeMonth").getValue()==true){
				if(RestMon==null){
					RestMon=3;
				}else{
					RestMon=RestMon+','+3;
				}
			}
			if(Ext.getCmp("FourMonth").getValue()==true){
				if(RestMon==null){
					RestMon=4;
				}else{
					RestMon=RestMon+','+4;
				}
			}
			if(Ext.getCmp("FiveMonth").getValue()==true){
				if(RestMon==null){
					RestMon=5;
				}else{
					RestMon=RestMon+','+5;
				}
			}
			if(Ext.getCmp("SixMonth").getValue()==true){
				if(RestMon==null){
					RestMon=6;
				}else{
					RestMon=RestMon+','+6;
				}
			}
			if(Ext.getCmp("SevenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=7;
				}else{
					RestMon=RestMon+','+7;
				}
			}
			if(Ext.getCmp("EightMonth").getValue()==true){
				if(RestMon==null){
					RestMon=8;
				}else{
					RestMon=RestMon+','+8;
				}
			}
			if(Ext.getCmp("NineMonth").getValue()==true){
				if(RestMon==null){
					RestMon=9;
				}else{
					RestMon=RestMon+','+9;
				}
			}
			if(Ext.getCmp("TenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=10;
				}else{
					RestMon=RestMon+','+10;
				}
			}
			if(Ext.getCmp("ElevenMonth").getValue()==true){
				if(RestMon==null){
					RestMon=11;
				}else{
					RestMon=RestMon+','+11;
				}
			}
			if(Ext.getCmp("TwelveMonth").getValue()==true){
				if(RestMon==null){
					RestMon=12;
				}else{
					RestMon=RestMon+','+12;
				}
			}
			if(Ext.getCmp("Normal").getValue()==true){
				if(RestMon==null){
					RestMon=13;
				}else{
					RestMon=RestMon+','+13;
				}
			}
			if(RestMon==null){Msg.info("warning", $g("请选择报警期限时间!"));
				return gStrParam;}
			gStrParam=phaLoc+"^"+date+"^"+RestMon+"^"+ZeroDrug+"^"+DHCStkCatGroup
			+"^"+UseFlag+"^"+StkGrpRowId;
			return gStrParam;
	
		}		
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			SetDefaultSCG();
			//Ext.getCmp("DHCStkCatGroup").setValue('');
			//Ext.getCmp("StkGrpType").setValue('');
			
			Ext.getCmp("Normal").setValue(false);
			Ext.getCmp("ZeroFlag").setValue(false);
			Ext.getCmp("ZeroMonth").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("OneMonth").setValue(false);
			Ext.getCmp("TwoMonth").setValue(false);
			Ext.getCmp("ThreeMonth").setValue(false);
			Ext.getCmp("FourMonth").setValue(false);
			Ext.getCmp("FiveMonth").setValue(false);
			Ext.getCmp("SixMonth").setValue(false);
			Ext.getCmp("SevenMonth").setValue(false);
			Ext.getCmp("EightMonth").setValue(false);
			Ext.getCmp("NineMonth").setValue(false);
			Ext.getCmp("TenMonth").setValue(false);
			Ext.getCmp("ElevenMonth").setValue(false);
			Ext.getCmp("TwelveMonth").setValue(false);
			StockQtyGrid.store.removeAll();
			StockQtyGrid.store.load({params:{start:0,limit:0}});
			StockQtyGrid.getView().refresh();
		}
		
		function MonthColorRenderer(val,meta){
			var monthcolor=""
			switch(parseInt(val)){
				case 0:
					monthcolor='classRed';
					val=$g("过期")
					break;
				case 1:
					monthcolor= 'classBlue';
					break;
				case 2:
					monthcolor= 'classYellow';
					break;
				case 3:
					monthcolor= 'classGrassGreen';
					break;
				case 4:
					monthcolor= 'classCyan';
					break;
				case 5:
					monthcolor= 'classOrange';
					break;
				case 6:
					monthcolor= 'classPink';
					break;
				case 7:
					monthcolor= 'classPurple';
					break;
				case 8:
					monthcolor= 'classLightBlue';
					break;
				case 9:
					monthcolor= 'classLightSeaGreen';
					break;
				case 10:
					monthcolor= 'classLime';
					break;
				case 11:
					monthcolor= 'classLightGoldenYellow';
					break;
				case 12:
					monthcolor= 'classDeepSkyBlue';
					break;
				default:
					monthcolor="";
					val=$g("正常")
					break;
			}  
			if (monthcolor!=""){
				meta.css=monthcolor;
			}
			if ((val!=$g("过期"))&&(val!=$g("正常"))&&(val!="")){
				if(val<10){
					val="0"+val+$g("月");
				}else{
					val=val+$g("月");
				}
			}
			return val;  
		}
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "inclb",
					dataIndex : 'inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('状态'),
					dataIndex : 'month',
					width : 80,
					align : 'center',
					sortable : true,
					renderer:MonthColorRenderer
				}, {
					header : $g('代码'),
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("名称"),
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g('批号'),
					dataIndex : 'batNo',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("效期"),
					dataIndex : 'expDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("库存"),
					dataIndex : 'stkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("单位"),
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'manf',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header :$g( "库存分类"),
					dataIndex : 'incscDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g('货位'),
					dataIndex : 'sbDesc',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : $g("最后一次入库经营企业"),
					dataIndex : 'lastvendorName',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header :$g( "失效天数"),
					dataIndex : 'warnDays',
					width : 80,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmBatOfExp&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["inclb", "inci", "code", "desc","spec", "manf", "incscDesc", "batNo",
				"expDate", "stkQty", "stkUom", "sbDesc","lastvendorName", "warnDays","month"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inclb",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
					//sortInfo: {field: "", direction: ""}
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
					emptyMsg : "No results to display",
					prevText : $g("上一页"),
					nextText : $g("下一页"),
					refreshText : $g("刷新"),
					lastText :$g( "最后页"),
					firstText : $g("第一页"),
					beforePageText : $g("当前页"),
					afterPageText : $g("共{0}页"),
					emptyMsg : $g("没有数据")
					
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar
					/*,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){
						var Month=record.get("month");
						Month=parseInt(Month);
						switch(Month){
							case 0:
								return 'classRed';
								break;
							case 1:
								return 'classBlue';
								break;	
							case 2:
								return 'classYellow';
								break;	
							case 3:
								return 'classGrassGreen';
								break;	
							case 4:
								return 'classCyan';
								break;
							case 5:
								return 'classOrange';
								break;
							case 6:
								return 'classPink';
								break;
							case 7:
								return 'classPurple';
								break;
							case 8:
								return 'classLightBlue';
								break;
							case 9:
								return 'classLightSeaGreen';
								break;
							case 10:
								return 'classLime';
								break;
							case 11:
								return 'classLightGoldenYellow';
								break;
							case 12:
								return 'classDeepSkyBlue';
								break;
							default:
								break;
						}            
                    }}*/
		});
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 90,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT,'-',PrintBT,'-',SaveAsBT],			   						
			items : [{
				layout : 'column',
				defaults:{border:false},	
				xtype:'fieldset',
				frame:false,
				title:$g("查询条件"),
				labelAlign : 'right',
				items : [{					
					defaults:{border:false},
					columnWidth : 1,
					xtype:'fieldset',
					labelAlign : 'right',		
					items : [PhaLoc,DateTime,StkGrpType,DHCStkCatGroup,ZeroFlag,NotUseFlag]
				}]},
				{
				layout : 'column',
				defaults:{border:false},	
				xtype:'fieldset',
				labelAlign : 'right',
				labelWidth:70,	
				title:$g("报警期限时间"),
				items : [{
					columnWidth : .5,
					xtype:'fieldset',	
					items : [
						Normal,OneMonth,ThreeMonth,FiveMonth,SevenMonth,NineMonth,NineMonth,ElevenMonth
					]
				},{
					defaults:{border:false},
					columnWidth : .5,
					xtype:'fieldset',	
					items : [
						ZeroMonth,TwoMonth,FourMonth,SixMonth,EightMonth,TenMonth,TwelveMonth
					]
				}]
			}]				
		   	
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 320,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('效期报警'),
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
			            }, {
			                region: 'center',
			                title: $g('明细'),			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	//获取默认月份
	var ParamProp=tkMakeServerCall("web.DHCST.LocItmExpDate","GetParamProp",gGroupId , gLocId , gUserId)
	var DefaultMonStr=ParamProp.split("^")[0]
	if(DefaultMonStr!=""){
		var MonCheckArr=["ZeroMonth","OneMonth","TwoMonth","ThreeMonth","FourMonth","FiveMonth","SixMonth","SevenMonth","EightMonth","NineMonth","TenMonth","ElevenMonth","TwelveMonth","Normal"]
		DefaultMonArr=DefaultMonStr.split(",")
		var len=DefaultMonArr.length
		for (i=0;i<len;i++){
			var Mon=DefaultMonArr[i]
			Mon=parseInt(Mon)
			if(Mon>13) Mon=13 
			Ext.getCmp(MonCheckArr[Mon]).setValue(true);
		}
		setTimeout(function(){searchData();},500)  //延迟调用查询的方法，等默认条件加载完成
	}
	
})