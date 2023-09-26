// /名称: 综合查询统计
// /描述: 综合查询统计
// /DispQuerySave.js
// /编写者：wyx
// /编写日期: 2014.05.26
var gNewCatId=""
Ext.onReady(function() {

	Ext.QuickTips.init();//用于浮窗提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL; //图片加载路径
	var gIncId='';
	var StrParam="";
	var gStrParam='';
	var gStrParamBatch='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
		//wyx add参数配置 2013-11-13
	if(gParam.length<1){
		GetParam();  //初始化参数配置
		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
           var DispLoc = new Ext.ux.DispLocComboBox({
					fieldLabel : '发药科室',
					id : 'DispLoc',
					name : 'DispLoc',
					anchor : '90%'
				});
	//病区
	var LocWard=new Ext.ux.LocWardComboBox({
		id : 'LocWard',
		name : 'LocWard',
		anchor:'90%'
	});

	var DateFrom = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		format : 'Y-m-d',
		value :DefaultStDate()
	});
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>开始时间</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});	
	var DateTo = new Ext.ux.EditDate({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		format : 'Y-m-d',
		value : DefaultEdDate()
	});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>截止时间</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
	//发药类别
	var DispType=new Ext.ux.DispTypeComboBox({
		id : 'DispType',
		name : 'DispType',
		anchor:'90%'
	});
	var InciDesc = new Ext.form.TextField({
					fieldLabel : '药品名称',
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								//var stkgrp=Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(),'');
							}
						}
					}
				});

				/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			//Ext.getCmp('InciDr').setValue(inciDr);			
			;			
		}
           //执行科室
           var ExeLoc = new Ext.ux.ExeLocComboBox({
					fieldLabel : '就诊科室',
					id : 'ExeLoc',
					name : 'ExeLoc',
					anchor : '90%'
		});
		// 药学大类
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : '药学大类',
					id : 'PhcCat',
					name : 'PhcCat',				
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PhccDesc'
				});
var PHCCATALL = new Ext.form.TextField({
	fieldLabel : '药学分类',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : '药学分类维护',
	handler : function() {	
       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    
     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
     
	var phacstr=retstr.split("^")
	GetAllCatNew(phacstr[0],phacstr[1])

    }
});	
				
						
		//医生科室
		var DocLoc = new Ext.ux.ComboBox({
					fieldLabel : '医生科室',
					id : 'DocLoc',
					name : 'DocLoc',			
					store : DocLocStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{FroLoc:'DispLoc'}
				});		
		//发药人
		var LocDispUser = new Ext.ux.ComboBox({
					fieldLabel : '发药人',
					id : 'LocDispUser',
					name : 'LocDispUser',			
					store : LocDispUserStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{FroLoc:'DispLoc'}
				});		
				
		var RetFlag = new Ext.form.Checkbox({
					fieldLabel : '包含退药',
					id : 'RetFlag',
					name : 'RetFlag',
					anchor : '90%',				
					height : 10,
					checked : false
				});


		var DocFlag = new Ext.form.Checkbox({
					fieldLabel : '仅医生科室',
					id : 'DocFlag',
					name : 'DocFlag',
					anchor : '90%',					
					height : 10,
					checked : false
				});				
				
				
				
				
				
				
				
				
				
				
				
				
							
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '统计',
					tooltip : '点击统计',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});
						// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_refresh',
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
			StrParam='';
			gStrParam='';
			Ext.getCmp("DispLoc").setValue('');
			Ext.getCmp("LocWard").setValue('');  
			Ext.getCmp("DateFrom").setValue(new Date());
			Ext.getCmp("DateTo").setValue(new Date());
			Ext.getCmp("StartTime").setValue(''); 
			Ext.getCmp("EndTime").setValue(''); 
			Ext.getCmp("DispType").setValue('');
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("ExeLoc").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("DocLoc").setValue('');
			Ext.getCmp("LocDispUser").setValue('');
			Ext.getCmp("PHCCATALL").setValue("");
			gNewCatId=""
			
		}
				
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT,'-','-','-','-','-','-',RefreshBT],			   						
			items : [{
						title:'选择条件',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[DispLoc,LocWard,DateFrom,StartTime,DateTo,EndTime,DispType,InciDesc,ExeLoc,PhcCat,DocLoc,LocDispUser]
						
					}, RetFlag,DocFlag
			]		  	
		});
//查询数据
function searchData()
 {

	 var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 var iframe = p.el.dom.getElementsByTagName("iframe")[0];
        var dispLoc = Ext.getCmp("DispLoc").getValue();
	 if (dispLoc ==""||dispLoc == null || dispLoc.length <= 0){
				Msg.info("warning", "发药科室不能为空！");
				Ext.getCmp("DispLoc").focus();
				return;
			}
        GetStrParam();
         iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispQuerySave_INCI_Common.raq&StrParam='+StrParam;	

 }		
					
///Tabs定义
    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0', 
	    activeTab: 0,
	    items:[{
	        title: '汇总',
	        id:'list',    
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
	           }
                ],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                     } 
                                
               } 
	    
     });		
	// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '发药统计',
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
			            }, {             
			                region: 'center',	
			                layout:'border',
			                items:[{
			                	region:'center',
			                	layout: 'fit', // specify layout manager for items
			                	items: QueryTabs    
			                }]             	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				///获取参数
function GetStrParam()
 {
	 var sDate=Ext.getCmp("DateFrom").getRawValue();       
        var eDate=Ext.getCmp("DateTo").getRawValue();
        
        var sTime=Ext.getCmp("StartTime").getRawValue();
        var eTime=Ext.getCmp("EndTime").getRawValue();
        var dispLoc = Ext.getCmp("DispLoc").getValue();
	 var locWard = Ext.getCmp("LocWard").getValue();
	 var locDispUser = Ext.getCmp("LocDispUser").getValue();
	 var dispType = Ext.getCmp("DispType").getValue();
	 var phcCat = Ext.getCmp("PhcCat").getValue();
	 var phcCatDesc = Ext.getCmp("PhcCat").getRawValue();
	 var inci = Ext.getCmp("InciDesc").getValue();
	 var inciDesc=Ext.getCmp("InciDesc").getRawValue();
	 var exeLoc = Ext.getCmp("ExeLoc").getValue();
	 var outflag="N"
	 if (dispType=="OUT") {outflag="Y";}
	 var docFlag = Ext.getCmp("DocFlag").getValue();
	 var docLoc = Ext.getCmp("DocLoc").getValue();
	 var retFlag = Ext.getCmp("RetFlag").getValue();

	 if(InciDesc==null || InciDesc==""){
		gIncId="";
	 }
///	  StrParam=开始日期^结束日期^发药科室^病区^发药人^发药类别^药学分类^药品名称^就诊科室^
///       出院带药标记^仅医生科室标记^开始时间^结束时间^医生科室^包含退药标记
	 StrParam= sDate+"^"+eDate+"^"+dispLoc+"^"+locWard+"^"+locDispUser+"^"+dispType+"^"+phcCat+"^"+inci+"^"+exeLoc+"^"+outflag+"^"+docFlag+"^"+sTime+"^"+eTime+"^"+docLoc+"^"+retFlag+"^"+gNewCatId ;
 }		
	
})