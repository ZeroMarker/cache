/*
///Title: 基础数据平台-基础数据
///Author: 陈莹、孙凤超 DHC-BDP
///Description: 医嘱项维护

///ofy1深圳宝安中医院↓ 最后一条如果医嘱代码是数字，则默认医嘱代码加1， 如果医嘱代码是字符串则默认医嘱代码为空
///ofy2南方医院 医嘱优先级默认为 临时医嘱
///ofy4同仁医院 类里加获取医保标志 ARCIMLinkInsu
///ofy6中日友好医院  限制正部病人使用
///ofy3河南省人民医院 医嘱项代码是 医嘱大类的代码 + 获取同一医嘱大类的下的最大生成码+1
///ofy7吉大三院 医嘱项关联医嘱项
///ofy8吉大三院 开医嘱限制
///ofy9 江西上饶第五人民医院  医嘱项关联试剂
///ofy10 医嘱项项目依赖  20170914新疆中医院、安徽亳州中医 协议处方
///ofy11 医嘱项位点  20170914中日友好医院
///ofy12 唐山人民 增加 结束并重新关联此收费项 按钮 2017-11-30 
 */
document.write('<script type="text/javascript" src="../scripts/framework/ext.icare.Lookup.js"></script>');
document.write('<style> .x-grid3-cell-inner {white-space:normal !important;} </style>'); //内容长的时候换行
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
var htmlurl = "../scripts/bdp/AppHelp/OrderItem/NEWARCItmMast.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"></script>');
/* 引用导入导出js2022-07-04 */
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/shim.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.full.min.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/Blob.js"> </script>');
//document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/FileSaver.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>');
///有结束日期的数据整行显示黄色背景
document.write("<style>.x-grid-record-color table{background: yellow;}</style>")
//var pinyins=Pinyin.GetJP("液状石蜡外用液体剂[500ml][吉林]")  小写
//alert(pinyins.toUpperCase());
//var pinyins=Pinyin.GetJPU("液状石蜡外用液体剂[500ml][吉林]")  大写


var limit = Ext.BDP.FunLib.PageSize.Main;
var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
var pagesize_main =  Ext.BDP.FunLib.PageSize.Main;
var pagesize_pop = Ext.BDP.FunLib.PageSize.pop;

var ArcItmMastStr, ZeroFeeStr, AddOrdLinkTar,  ArcimCheckboxStr;
var ArrayTarCopy = [];//用于保存要复制的收费关联项
var arcimrowid="";  //arc_itmmast表的Rowid
var OltRowid="";   //医嘱项与收费项目关联表的Rowid
var lookup,tarInfo="",winlookup,copylookup;



Ext.onReady(function() {
    
    
    Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.2.1/resources/images/default/s.gif'; 
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
    
    var TodayDate=(new Date()).format(BDPDateFormat);
    var TodayDate1=new Date();
    var YesterdayDate = (new Date(TodayDate1.getTime() - 24*60*60*1000)).format(BDPDateFormat);
    var TomorrowDate = (new Date(TodayDate1.getTime() + 24*60*60*1000)).format(BDPDateFormat);
    /*//初始化"别名"维护面板
    var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
        TableN : "ARC_ItmMast"
    });
    */
    
    /********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.ARCItmMast";
    var btnSort = Ext.BDP.FunLib.SortBtn;
   
     
     Ext.BDP.FunLib.TableName="ARC_ItmMast"
     var btnTrans=Ext.BDP.FunLib.TranslationBtn;
     var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
     if (TransFlag=="false")
     {
        btnTrans.hidden=false;
      }
     else
     {
        btnTrans.hidden=true;
     }
     
     /////////////////////////////日志查看 ////////////////////////////////////////
    /// var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName+"^User.DHCOrderLinkTar");
    var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
    var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu) 
    var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
    ///日志查看按钮是否显示
    var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
    if (btnlogflag==1)
    {
        btnlog.hidden=false;
    }
    else
    {
       btnlog.hidden=true;
    }
    /// 数据生命周期按钮 是否显示
    var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
    if (btnhislogflag ==1)
    {
        btnhislog.hidden=false;
    }
    else
    {
        btnhislog.hidden=true;
    }  
    btnhislog.on('click', function(btn,e){    
        var RowID="",Desc="";
        if (grid.selModel.hasSelection()) {
            var rows = grid.getSelectionModel().getSelections(); 
            RowID=rows[0].get('ARCIMRowId');
            Desc=rows[0].get('ARCIMDesc');
            var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
        }
    else
    {
        var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
        }
    });
    
    var DataType=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",Ext.BDP.FunLib.TableName);
     
    //多院区医院下拉框
    var hospComp=GenHospComp(Ext.BDP.FunLib.TableName); 
    //医院下拉框选择一条医院记录后执行此函数
    hospComp.on('select',function (){
        
        
        var p1 = Ext.getCmp("code").getValue(); //代码
         var p2 = Ext.getCmp("desc").getValue(); //描述   
         var p3 = "" //Ext.getCmp("drugmastcode").getValue(); //药物
         var p4 = Ext.getCmp("alias").getValue(); //别名                       
         Ext.getCmp("billgroup").setValue(""); //账单组    
         Ext.getCmp("subbillgroup").setValue(""); //账单子组    
         Ext.getCmp("ordersubsort").setValue(""); //医嘱子类                         
         Ext.getCmp("servicegroup").setValue(""); //服务组
         Ext.getCmp("ordercat").setValue("")  //医嘱子类
         var enableflag = Ext.getCmp("enableflag").getValue();
     
         grid.getStore().baseParams={
            hospid:hospComp.getValue(),
            P1:p1,P2:p2,P3:p3,P4:p4,P5:"",P6:"",P7:"",P8:"",
            enableflag:enableflag,
            ownflag:Ext.getCmp("ownflag").getValue(),
            ordercat:"",
            datefrom:Ext.getCmp("datefrom").getRawValue(),
            limittype:Ext.getCmp("limittype").getValue()
         };
         gridstore.load({
            params:{start:0, limit:pagesize_main},
            callback: function(records, options, success){
            }
          }); 
        
    });
    
    
    var OrderCatDR_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassQuery=GetDataForCmb1";
    //医院ComboBox取值URL
    var Hosp_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
    //调用获取医院组的接口
    var Hosp_Comp_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCombo"+"&tablename="+"ARC_ItmMast";
    var ItemCat_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
    //// 账单组查询数据
    var BillGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillGrp&pClassQuery=GetDataForCmb1";
    //费用标准
    var ARCDerivedFeeRules_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCDerivedFeeRules&pClassQuery=GetDataForCmb1";
    /// 账单子组查询数据
    var BillSubGroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCBillSub&pClassQuery=GetDataForCmb1";
    /// 账单单位查询数据
    var BillUnit_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTUOM&pClassQuery=GetDataForCmb1";
    /// 急诊优先级查询数据
    var defaultpriority_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
    ///服务组查询数据
    var resourcegroup_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.RBCServiceGroup&pClassQuery=GetDataForCmb1";
    
    /// 关联零收费项-收费子分类
    var SubCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarSubCate&pClassQuery=GetDataForCmb1";
    /// 关联零收费项-会计子分类combox
    var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarAcctCate&pClassQuery=GetDataForCmb1";
    /// 关联零收费项-住院子分类 combox
    var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarInpatCate&pClassQuery=GetDataForCmb1";
    /// 关联零收费项-门诊子分类combox
    var OutpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarOutpatCate&pClassQuery=GetDataForCmb1";    
    /// 关联零收费项-核算子分类combox
    var EMCCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarEMCCate&pClassQuery=GetDataForCmb1";
    ///关联零收费项-病案首页子分类combox
    var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCTarMRCate&pClassQuery=GetDataForCmb1";
    ///  关联零收费项-新病案首页子分类combox
    var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCNewTarMRCate&pClassQuery=GetDataForCmb1";
    /// 限患者类型
    var LIMITTYPE_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetOrderLimtForCmb1";
    
    /*
    ///收费项目子类
    var SubCate_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=chargesubcat";
    //收费会计子类
    var AcctCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=acctsubcat";
    //// 住院费用子类
    var InpatCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=inpatsubcat";
    /// 门诊费用子类
    var OutpatCate_ACTION_URL =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=outpatsubcat";
    /// 经济核算子类
    var EMCCate_ACTION_URL ="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=emcsubcat";
    /// 旧病案首页子类
    var MRCate_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=mrsubcat";
    /// 新病案首页子类
    var MCNew_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassQuery=GetMCNew";
    */
    
    
    ///  药物查找
    var GetDrugList_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassQuery=GetDrugList";
    /// 其他明细中的药物
    //var drugmast_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassMethod=drugmast";
    /// 其他明细 中的 药物形态
    ///var drugform_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.QueryForARCItmMast&pClassMethod=drugform";
    
    /// 获取 医嘱项与收费项目关联 grid数据
    var OrderLinkTar_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassQuery=GetList";
    ///   修改医嘱项语医嘱项关联
    var UpdateOrdLinkTar_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassMethod=UpdateOrdLinkTar";
    ///   添加医嘱项与收费项目关联
    var AddOrdLinkTar_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassMethod=AddOrdLinkTar";
    ///   删除医嘱项与收费项目关联
    var DelOrderLinkTar_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCOrderLinkTar&pClassMethod=DelOrderLinkTar";
    
    /// 查询医嘱项列表
    //var GetList_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetList2";
   var GetList_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetList";

    /// 医嘱项 添加/医嘱复制
    var ARCIM_Save_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=Save";
    /// 医嘱项 修改
    var ARCIM_Update_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=update";
    /// 医嘱项删除数据
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=DeleteData";
    var ARCIM_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
    
    /// 医嘱项医院关联
    var Hosp_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemHosp&pClassQuery=GetList";
    var AddHosp_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemHosp&pClassMethod=AddARCItemHosp";
    var UpdateHosp_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemHosp&pClassMethod=UpdateOrderARCItemHosp";
    var DeleteHosp_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemHosp&pClassMethod=DeleteData";
    var MultiAddHosp_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemHosp&pClassMethod=MultiAddHosp";
    
    /// 医嘱项别名
    var ALIAS_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCAlias&pClassQuery=GetList";
    var AddOrderAlias_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCAlias&pClassMethod=AddOrderAlias";
    var UpdateOrderAlias_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCAlias&pClassMethod=UpdateOrderAlias";
    var DeleteOrderAlias_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCAlias&pClassMethod=DeleteData";
    var MultiAddAlias_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCAlias&pClassMethod=MultiAddAlias";
    
    /// 年龄/性别限制
    var AGESEX_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemAgeSexRestriction&pClassQuery=GetList";
    var AddOrderAgeSex_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAgeSexRestriction&pClassMethod=AddData";
    var MultiAddOrderAgeSex_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAgeSexRestriction&pClassMethod=MultiAddAgeSex";
    var UpdateOrderAgeSex_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAgeSexRestriction&pClassMethod=UpdateData";
    var DeleteOrderAgeSex_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAgeSexRestriction&pClassMethod=DeleteData";
    var CTSEXQUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
    
    /// 医嘱项外部代码
    var ExternalCode_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemExternalCodes&pClassQuery=GetList";
    var AddOrderExtCode_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemExternalCodes&pClassMethod=AddOrderExtCode";
    var UpdateOrderExtCode_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemExternalCodes&pClassMethod=UpdateOrderExtCode";
    var DeleteOrderExtCode_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemExternalCodes&pClassMethod=DeleteData";
    var MultiAddExtCode_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemExternalCodes&pClassMethod=MultiAddExtCode";
    
    /// 医嘱项接收科室
    var ARCRecLoc_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassQuery=GetList";
    var AddReceiveLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=AddReceiveLoc";
    var UpdateRecLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=UpdateRecLoc";
    var DeleteReceiveLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=DeleteData";
    var Priority_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
    var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
    var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
    var MultiAddRecLoc_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=MultiAddRecLoc";
    
    /// 医嘱项过敏原URL
    /*var Allergy_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassQuery=GetList";
    var AddAllergy_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=AddOrderAllergy";
    var UpdateAllergy_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=UpdateOrderAllergy";
    var DeleteAllergy_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=DeleteData";
    var  MultiAddAllergy_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=MultiAddAllergy";
    
    var ALGType_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassQuery=GetDataForCmb1";
    var ALGDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassQuery=GetComboList";
    var FINDDR_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=FindDR";
    var GETTAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemAllergy&pClassMethod=FindTagByType";
    */
    var comValue=0, PerPrice=0 ,totalPrice=0 ,enddateValue="", PriceCount=0;
    
    
    
    /////保存医嘱项的历史开始日期结束日期记录
    var DateUpd_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastUpdInfo&pClassQuery=GetList";

    ///医嘱项有效日期修改记录 查询
    var DateUpdds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : DateUpd_QUERY_ACTION_URL }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                            
                                    name : 'DUPDIRowId',
                                    mapping : 'DUPDIRowId',
                                    type : 'string'
                                }, {
                                    name : 'DUPDIEffDate',
                                    mapping : 'DUPDIEffDate',
                                    type : 'string'
                                }, {
                                    name : 'DUPDIEffDateTo',
                                    mapping : 'DUPDIEffDateTo',
                                    type : 'string'
                                }, {
                                    name : 'DUPDIUpdDate',   //date string query里转换
                                    mapping : 'DUPDIUpdDate',
                                    type : 'string'
                                }, {
                                    name : 'DUPDIUpdTime',
                                    mapping : 'DUPDIUpdTime',
                                    type : 'string'
                                }, {
                                    name : 'DUPDIUpdUser',
                                    mapping : 'DUPDIUpdUser',
                                    type : 'string'
                                
                                }// 列的映射
                        ])
            });
    var DateUpdPaging = new Ext.PagingToolbar({
                pageSize : 10,
                store : DateUpdds,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
                emptyMsg : "没有记录",
                plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                   "change" : function(t, p) {
                        pagesize_pop = this.pageSize;
                    }
                }
            });
    
/*  DateUpdds.on('beforeload',function() {
                    var gsm = grid.getSelectionModel();// 获取选择列
                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                    Ext.apply(DateUpdds.lastOptions.params, {
                        arcimrowid : rows[0].get('ARCIMRowId')
                    });
            },this);
    */
    var DateUpdgrid = new Ext.grid.GridPanel({
                id : 'DateUpdgrid',
                region : 'center',
                closable : true,
                store : DateUpdds,
                trackMouseOver : true,
                columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
                        {
                            header : 'DUPDIRowId',
                            sortable : true,
                            dataIndex : 'DUPDIRowId',
                            hidden : true
                        }, {
                            header : '开始日期',
                            sortable : true,
                            dataIndex : 'DUPDIEffDate',
                            width : 160
                        }, {
                            header : '结束日期',
                            sortable : true,
                            dataIndex : 'DUPDIEffDateTo',
                            width : 160
                        }, {
                            header : '修改日期',
                            sortable : true,
                            width:160,
                            dataIndex : 'DUPDIUpdDate'
                        }, {
                            header : '修改时间',
                            sortable : true,
                            dataIndex : 'DUPDIUpdTime'
                        }, {
                            header : '操作人',
                            sortable : true,
                            dataIndex : 'DUPDIUpdUser'
                        
                        }],
                stripeRows : true,
                //stateful : true,
                viewConfig : {
                    forceFit : true
                },
                columnLines : true, //在列分隔处显示分隔符
                sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
                bbar : DateUpdPaging
            }); 
    

    var DateUpdlist_win = new Ext.Window({
                    iconCls : 'icon-AdmType',
                    width : Ext.getBody().getWidth()*0.96,
                    height : 500,//Ext.getBody().getHeight()*.9,
                    layout : 'fit',
                    plain : true,// true则主体背景透明
                    modal : true,
                    //frame : true,
                    autoScroll : true,
                    collapsible : true,
                    hideCollapseTool : true,
                    titleCollapse : true,
                    //bodyStyle : 'padding:3px',
                    constrain : true,
                    closeAction : 'hide',
                    items : [DateUpdgrid],
                    listeners : {
                        "show" : function(){
                                                
                        },
                        "hide" : function(){
                            
                        },
                        "close" : function(){
                        }
                    }
                });
    
    var btnEff = new Ext.Toolbar.Button({
                text : '有效期查询',
                tooltip : '医嘱项历史有效期记录查询',
                iconCls : 'icon-AdmType',
                id:'btnEff',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnEff'),
                handler : function() {
                    if (grid.selModel.hasSelection()) {
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        DateUpdds.baseParams={arcimrowid:rows[0].get('ARCIMRowId')};
                        DateUpdds.load({
                                params : {
                                        start : 0,
                                        limit : pagesize_pop
                                    }
                            });
                        
                        DateUpdlist_win.setTitle(rows[0].get('ARCIMDesc')+"---医嘱项历史有效期查询");
                        DateUpdlist_win.show();
                    } else {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择一条医嘱项!',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
                    }
                }
            });
    
    /// 医嘱限制的维护 
    var btnLocAut = new Ext.Toolbar.Button({
                text : '医嘱限制',
                tooltip : '医嘱限制',
                iconCls : 'icon-DP',
                id:'aut_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('aut_btn'),
                items:grid,
                handler : UpdateData=function() {
                var records =  grid.selModel.getSelections();
                var recordsLen= records.length;
                if(recordsLen == 0){
                        Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'请选择一条医嘱项!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
                     return
                 } 
                 else{
                        var ParRef = grid.getSelectionModel().getSelections()[0].get('ARCIMRowId')
                        var link="dhc.bdp.ext.default.csp?extfilename=App/OrderItem/DHC_ArcItemAut&ParRef="+ParRef+"&hospid="+hospComp.getValue(); 
                        if ('undefined'!==typeof websys_getMWToken){
                            link += "&MWToken="+websys_getMWToken()
                        }
                        var link=encodeURI(link)
                        var ArcItemAutWin = new Ext.Window({
                                        title:'医嘱限制->'+ grid.getSelectionModel().getSelections()[0].get('ARCIMDesc'),
                                        width :1000,
                                        height :Math.min(Ext.getBody().getHeight()-100,700),
                                        layout : 'fit',
                                        plain : true, 
                                        modal : true,
                                        frame : true,
                                        constrain : true,
                                        closeAction : 'hide'  
                        });
                        ArcItemAutWin.html='<iframe src=" '+link+' " width="100%" height="100%"></iframe>';
                        ArcItemAutWin.show(); 
                     }
             }
    });



    
    ////增加配置维护页面  2017-03-20 
    /*1,是否自动关联医院
     *2,是否自动生成拼音码
     *3,是否自动生成五笔码 
     *4 是否自动生成代码
     *5 自动生成代码规则 F O OA A
     *6 代码总长度
     *7 规则为F时 代码开头字符 可以为空
     */     
      
    var config_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetConfigValue";
    var config_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=SaveConfigValue";
       
        
    var configWinForm = new Ext.FormPanel({
                id : 'config-form-save',
                URL : config_SAVE_ACTION_URL,
                labelAlign : 'right',
                labelWidth : 100,
                split : true,
                frame : true,   
                waitMsgTarget : true,
                reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        // {name: 'LinkHospital',mapping:'LinkHospital'},
                                         {name: 'FirstFightAlias',mapping:'FirstFightAlias'},
                                         {name: 'FivePenAlias',mapping:'FivePenAlias'},
                                         {name: 'AutoCode',mapping:'AutoCode'},
                                         {name: 'ACode',mapping:'ACode'},
                                         {name: 'OACode',mapping:'OACode'},
                                         {name: 'FCode',mapping:'FCode'},
                                         {name: 'OCode',mapping:'OCode'},
                                         {name: 'OriginCode',mapping:'OriginCode'},
                                         {name: 'TotalLength',mapping:'TotalLength'},
                                         {name: 'ValidDesc',mapping:'ValidDesc'},
                                         {name: 'CodeAlias',mapping:'CodeAlias'}
                                        ]),
                defaults : {
                    anchor : '90%',
                    bosrder : false
                },
                items : [{
                        /*xtype:'checkbox',
                        boxLabel:'添加/复制医嘱项时，医嘱项自动关联医院',
                        id:'LinkHospital',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LinkHospital'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LinkHospital')),
                        inputValue:'Y'
                    }, {*/
                        xtype:'checkbox',
                        boxLabel:'添加/复制医嘱项时，别名里自动添加拼音码首拼',
                        id:'FirstFightAlias',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('FirstFightAlias'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FirstFightAlias')),
                        inputValue:'Y'
                    },{
                        xtype:'checkbox',
                        boxLabel:'添加/复制医嘱项时，别名里自动添加五笔码首拼',
                        id:'FivePenAlias',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('FivePenAlias'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FivePenAlias')),
                        inputValue:'Y'
                    },{
                        xtype:'checkbox',
                        boxLabel:'添加/复制医嘱项时，别名里自动添加代码',    
                        id:'CodeAlias',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CodeAlias'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CodeAlias')),
                        inputValue:'Y'
                    }, {
                        xtype:'checkbox',
                        inputValue:'Y',
                        boxLabel:'校验名称是否重复',
                        id:'ValidDesc',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ValidDesc'))
                    },{
                        xtype : 'fieldset',
                        title:'自动生成代码',
                        items:[
                        {
                        
                            boxLabel :'自动生成代码(字母+数字或者纯数字编码)',   //默认不自动生成
                            name: 'AutoCode',
                            id:'AutoCode',
                            xtype:'checkbox',
                            listeners:{
                                'check':function(checked){
                                       if(checked.checked){
                                            
                                            Ext.getCmp("FCode").setDisabled(false);
                                            Ext.getCmp("OACode").setDisabled(false);
                                            Ext.getCmp("OCode").setDisabled(false);
                                            Ext.getCmp("ACode").setDisabled(false);
                                            Ext.getCmp("TotalLength").setDisabled(false);
                                            
                                            if(Ext.getCmp("FCode").checked){
                                                Ext.getCmp("OriginCode").setDisabled(false);
        
                                            }else{
                                                Ext.getCmp("OriginCode").setDisabled(true); 
                                            }
                                            
                                        }else{
                                            
                                            Ext.getCmp("FCode").setDisabled(true);
                                            Ext.getCmp("OACode").setDisabled(true);
                                            Ext.getCmp("OCode").setDisabled(true);
                                            Ext.getCmp("ACode").setDisabled(true);
                                            Ext.getCmp("TotalLength").setDisabled(true);
                                            Ext.getCmp("OriginCode").setDisabled(true);
                                            
                                        }
                                }
                            }
                            
                            
                        },{
                            xtype: 'radio', 
                            id:'FCode',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('FCode'),
                            boxLabel: '自定义',
                            name: 'CodeType',
                            inputValue: 'F',
                            listeners:{
                                'check':function(checked){
                                    
                                     if(Ext.getCmp("AutoCode").checked){
                                    
                                       if(checked.checked){
                                            Ext.getCmp("OriginCode").setDisabled(false);
    
                                        }else{
                                            Ext.getCmp("OriginCode").setDisabled(true); 
                                        }
                                     }
                                }
                            }
                        },{
                            fieldLabel : '代码起始字符',
                            name: 'OriginCode',
                            xtype:'textfield',
                            id:'OriginCode',
                            disabled:true 
                        },{
                            xtype: 'radio', 
                            id:'OACode',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('OACode'),
                            name: 'CodeType',
                            boxLabel: '医嘱大类+子类代码',
                            inputValue: 'OA' 
                        }, {
                            xtype: 'radio', 
                            id:'OCode',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('OCode'),
                            name: 'CodeType',
                            labelSeparator: '',
                            boxLabel: '医嘱大类代码',
                            inputValue: 'O' 
                        }, {
                            xtype: 'radio', 
                            id:'ACode',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ACode'),
                            name: 'CodeType',
                            labelSeparator: '',
                            boxLabel: '医嘱子类代码',
                            inputValue: 'A'        
                        },{
                            fieldLabel : '<font color=red>*</font>代码总长度',
                            name: 'TotalLength',
                            xtype:'numberfield',
                            minValue : 1,
                            allowNegative : false,//不允许输入负数
                            allowDecimals : false,//不允许输入小数
                            id:'TotalLength',
                            disabled:true
                        }]
                    
                    }
                    ]
    });
        
    // 增加修改时弹出窗口
    var configwin = new Ext.Window({
        title : '',
        width : 540,
        minWidth:540,
        height: 490,
        layout : 'fit',
        closeAction : 'hide',
        plain : true, 
        modal : true,
        frame : true,
        autoScroll : true,
        hideCollapseTool : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        items : configWinForm, 
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'configsave_btn',
            handler : function() { 
                    var AutoCode=Ext.getCmp('AutoCode').getValue();
                    var OriginCode=Ext.getCmp('OriginCode').getValue();
                    var TotalLength=Ext.getCmp('TotalLength').getValue();
                    var CodeType=""
                    if (AutoCode==true)
                    {
                        if (TotalLength=="") {
                            Ext.Msg.show({ title : '提示', msg : '代码总长度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                            return;
                        }
                        
                        if ((OriginCode!="")&&(TotalLength!=""))
                        {
                            if (TotalLength<=(OriginCode.length))
                            {
                                Ext.Msg.show({ title : '提示', msg : '代码起始字符的长度必须小于代码总长度!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                                return;
                            }
                        }
                        if (Ext.getCmp("FCode").getValue()==true)
                        {
                            CodeType="F"
                        }
                        else if (Ext.getCmp("OACode").getValue()==true)
                        {
                            CodeType="OA"
                        }
                        else if (Ext.getCmp("ACode").getValue()==true)
                        {
                            CodeType="A"
                        }
                        else if (Ext.getCmp("OCode").getValue()==true)
                        {
                            CodeType="O"
                        }
                        else
                        {
                            
                            Ext.Msg.show({ title : '提示', msg : '请选择一个代码生成规则!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
                            return;
                        }
                    }
                    //-------保存---------- Ext.getCmp('LinkHospital').getValue()
                    var ConfigStr=""+'^'+Ext.getCmp('FirstFightAlias').getValue()+'^'+Ext.getCmp('FivePenAlias').getValue()+"^"+Ext.getCmp('AutoCode').getValue()+'^'+CodeType     ///1~5
                    ConfigStr=ConfigStr+'^'+Ext.getCmp('TotalLength').getValue()+'^'+Ext.getCmp('OriginCode').getValue()+'^'+Ext.getCmp('ValidDesc').getValue()+'^'+Ext.getCmp('CodeAlias').getValue();    ///6~9

                    Ext.Ajax.request({
                            url : config_SAVE_ACTION_URL, 
                            method : 'POST',
                            params : {
                                'ConfigStr' :ConfigStr,
                                'hospid':hospComp.getValue()
                            },
                            callback : function(options, success, response) {
                                Ext.MessageBox.hide();
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true')
                                    {
                                        configwin.hide();          
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '配置保存成功！',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK
                                    });
                                }
                                else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br/>错误信息:'+ jsonData.info
                                        }
                                        Ext.Msg.show({
                                                    title : '提示',
                                                    msg : '配置保存失败！' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }
                                } 
                                else {
                                    Ext.Msg.show({
                                                title : '提示',
                                                msg : '异步通讯失败,请检查网络连接！',
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                }
                            }
                        }, this);
                    
    
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                configwin.hide();
            }
        }],
        listeners : {
            "show" : function() {
                
                
                if(Ext.getCmp("AutoCode").checked){
                                        
                    Ext.getCmp("FCode").setDisabled(false);
                    Ext.getCmp("OACode").setDisabled(false);
                    Ext.getCmp("OCode").setDisabled(false);
                    Ext.getCmp("ACode").setDisabled(false);
                    Ext.getCmp("TotalLength").setDisabled(false);
                    
                    if(Ext.getCmp("FCode").checked){
                        Ext.getCmp("OriginCode").setDisabled(false);

                    }else{
                        Ext.getCmp("OriginCode").setDisabled(true); 
                    }
                    
                }else{
                    
                    Ext.getCmp("FCode").setDisabled(true);
                    Ext.getCmp("OACode").setDisabled(true);
                    Ext.getCmp("OCode").setDisabled(true);
                    Ext.getCmp("ACode").setDisabled(true);
                    Ext.getCmp("TotalLength").setDisabled(true);
                    Ext.getCmp("OriginCode").setDisabled(true);
                    
                }
            },
            "hide" : function() {
            
            },
            "close" : function() {
            }
        }
    });
    
    
    var btnConfig = new Ext.Button({
        text : '配置',
        id:'btnConfig',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnConfig'),
        iconCls : 'icon-config',
        handler : function() {
            Ext.getCmp("config-form-save").getForm().reset()
            Ext.getCmp("config-form-save").getForm().load( {
                        url : config_OPEN_ACTION_URL+ '&hospid='+ hospComp.getValue(),
                        //waitMsg : '正在载入数据...',
                     success : function(form,action) {
                        //Ext.Msg.alert('编辑','载入成功！');
                        },
                        failure : function(form,action) {
                            Ext.Msg.alert('编辑','载入失败！');
                     }
                    });
                    
            configwin.setTitle('配置');
            configwin.setIconClass('icon-config');
            configwin.show();
            
        }
    });
    
    
 
    /***************************************封装一个功能函数,用于加载combox数据*********************************/
    loadParams=function(grid,Params1,Params2,Params3){
        var record = grid.getSelectionModel().getSelected(); 
        Ext.getCmp(Params1).store.load({
            params:'',
            callback: function(records, options, success){
                Ext.getCmp(Params1).setValue(record.data[Params2]);
                Ext.getCmp(Params1).setRawValue(record.data[Params3]);
            }
        }); 
    }
    
    ////////////////////////////////////////   以下为医嘱项过敏原      /////////////////////////////////////////////////////////////////
    
    /** ******************************医嘱项关联过敏原的存储store******************************************************* */
    /*var OrderAllergyStore = new Ext.data.Store({
        proxy : new Ext.data.HttpProxy({
                url : Allergy_ACTION_URL
        }),
        reader : new Ext.data.JsonReader({
                totalProperty : 'total',
                root : 'data',
                successProperty : 'success'
            },  [{
                    name : 'ALGRowId',
                    mapping : 'ALGRowId',
                    type : 'string'
            }, {
                    name:'ShowRowId',
                    mapping:'ShowRowId',
                    type:'string'
            },{
                    name : 'MRCATTag',
                    mapping : 'MRCATTag',
                    type : 'string'
            },{
                    name : 'Table',
                    mapping : 'Table',
                    type : 'string'
            }, {
                    name : 'AllergyDesc',
                    mapping : 'AllergyDesc',
                    type : 'string'
            },{
                    name:'AllergyDR',
                    mapping:'AllergyDR',
                    type:'string'
            } 
        ])
    });
    
    
    //删除医嘱项过敏原
    var DeleteOrderAllergy = function() {
        if (arcimrowid=="")
        {
            Ext.Msg.show({
                            title : '提示',
                            msg : "请选择一条医嘱项!",
                            icon : Ext.Msg.INFO,
                            buttons : Ext.Msg.OK
                        });
            return;
        }
        if(OrderAllergyList.selModel.hasSelection()){
           var gsm = OrderAllergyList.getSelectionModel(); 
           var rows = gsm.getSelections(); 
           Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
           if(btn=='yes'){
                var DelAllergyRowid=rows[0].get('ALGRowId');
                Ext.Ajax.request({
                            url : DeleteAllergy_ACTION_URL,
                            method : 'POST',
                            params : {
                                'rowid' : rows[0].get('ALGRowId')
                            },
                            callback : function(options, success, response) {
                            if (success) {
                                    resetAllergyForUpdate()
                            } else {
                                            Ext.Msg.show({
                                                    title : '提示',
                                                    msg : "医嘱项过敏原删除失败!",
                                                    icon : Ext.Msg.INFO,
                                                    buttons : Ext.Msg.OK
                                                });
                                            }
                                        }
                                    })
                                }
                            });
                      }
                      else{
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : "未选中过敏原!",
                                    icon : Ext.Msg.INFO,
                                    buttons : Ext.Msg.OK
                                });
                         }
                    }
    //添加医嘱项过敏原
    var AddOrderAllergyFun = function() {
        var AllergyStr = "";
        if(Ext.getCmp("txtAllergen").getValue()=="")
        {
            Ext.Msg.show({
                    title : '提示',
                    msg : "过敏原不能为空!",
                    icon : Ext.Msg.INFO,
                    buttons : Ext.Msg.OK
                });
            return false;
        }
         
        AllergyStr = arcimrowid + "^" + Ext.getCmp("txtAllergenType").getValue() + "^" + Ext.getCmp("txtAllergen").getValue();
        Ext.Ajax.request({
            url : AddAllergy_ACTION_URL,
            method : 'POST',
            params : {
                'SaveDataStr' : AllergyStr
            },
            callback : function(options, success, response) {
                if (success) {
                    var jsonData = Ext.util.JSON.decode(response.responseText);
                    if (jsonData.success == 'true') {
                                Ext.Msg.show({
                                    title : '提示',
                                    msg : jsonData.info,
                                    icon : Ext.Msg.INFO,
                                    buttons : Ext.Msg.OK,
                                    fn : function(btn) {
                                        
                                        resetAllergyForUpdate()
                                    }
                                });
                    } else {
                                Ext.Msg.show({
                                        title : '提示',
                                        msg : jsonData.info,
                                        icon : Ext.Msg.ERROR,
                                        buttons : Ext.Msg.OK
                                    });
                            resetAllergyForUpdate()
                        }
                    } else {
                        Ext.Msg.show({
                                        title : '提示',
                                        msg : "医嘱项关联过敏原添加失败!",
                                        icon : Ext.Msg.ERROR,
                                        buttons : Ext.Msg.OK
                                    });
                        resetAllergyForUpdate()
                    }
                }
        })
    };
 
    ////////////////////////////// window弹窗的快速添加 过敏原数据//////////////////////////////////////////////////
    
     var MultiAddAllergy= function(rowid){
             var ARCAllergyCount=winOrderAllergyStore.getCount();
             if (ARCAllergyCount!=0){
                    AddAllergyStr="";
                    winOrderAllergyStore.each(function(record){
                    if(AddAllergyStr!="") AddAllergyStr = AddAllergyStr+"*"; /// 传值  过敏原类型和过敏原的id
                        AddAllergyStr = AddAllergyStr+record.get('ShowRowId')+'^'+record.get('AllergyDR');
                    }, this);
                }
                else{
                    AddAllergyStr="";
                }
            Ext.Ajax.request({
                url:MultiAddAllergy_URL,
                method:'POST',
                params:{
                    'rowid':rowid,
                    'AddAllergyStr':AddAllergyStr
                }
        });  
    }   
    
    //修改医嘱项关联过敏原
    var EditOrderAllergy = function() 
    {
        var AllergyStr = "";
        if (arcimrowid == "") 
        {
            Ext.Msg.show({
                            title:'提示',
                            msg:"请选择一条医嘱项!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            return;
        }
        var records = OrderAllergyList.selModel.getSelections();
        if (records.length == 0) 
        {
            Ext.Msg.show({
                            title:'提示',
                            msg:"未选中过敏原!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            Ext.getCmp("txtAllergenType").reset();
            Ext.getCmp("txtAllergen").reset();
            AllergyStr = "";
            return;
        }
        
        if (records.length>0){
            var ALGRowId = records[0].get('ALGRowId');
            var AlleryData=Ext.getCmp("txtAllergen").getValue();
            var TagID = Ext.getCmp("txtAllergenType").getValue();
            var MTag=records[0].get('MRCATTag');
            if (AlleryData==""){
                Ext.Msg.show({
                            title:'提示',
                            msg:"过敏原不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
                return 
            }
            
            
            var UpdateOrderAllergyStr=ALGRowId+'^'+TagID+'^'+AlleryData+'^'+MTag
            
            Ext.Ajax.request({
                url : UpdateAllergy_ACTION_URL,
                method : 'POST',
                params : {
                    'UpdateOrderAllergyStr' :UpdateOrderAllergyStr
                    
                },  
                callback : function(options, success, response) {
                    if (success) {
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if (jsonData.success == 'true') {
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : jsonData.info,
                                    icon : Ext.Msg.INFO,
                                    buttons : Ext.Msg.OK,
                                    fn : function(btn) {
                                        resetAllergyForUpdate()
                                    }
                                });
                    } else {
                        Ext.Msg.show({
                                        title : '提示',
                                        msg : jsonData.info,
                                        icon : Ext.Msg.ERROR,
                                        buttons : Ext.Msg.OK
                                    });
                            }
                    } else {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"关联过敏原修改失败!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            resetAllergyForUpdate()
                        }
                    }
            })
        }
    };

    
    //过敏原维护的面板
    // / 第二个下拉框 过敏原store
    var Referenceds = new Ext.data.JsonStore({
            id : 'Referenceds',
            url:ALGDR_QUERY_ACTION_URL,
            root: 'data',
            totalProperty: 'total',
            idProperty: 'RowId',
            fields:['RowId','AllergyDesc']
        });
        
    var txtAllergen = new Ext.BDP.Component.form.ComboBox({
            fieldLabel : '<font color=red>*</font>过敏原',
            width : 155,
            allowBlank : false,
            id : 'txtAllergen',
            hiddenName:'txtAllergen2',
            readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtAllergen'),
            style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtAllergen')),
            store : Referenceds,
            triggerAction:'query', 
            forceSelection: true,
            selectOnFocus:false,
            mode:'remote',
            pageSize:Ext.BDP.FunLib.PageSize.Combo,
            minChars: 0,
            listWidth:250,
            loadByIdParam : 'rowid',
            queryParam : 'desc',
            displayField : 'AllergyDesc',
            valueField : 'RowId',
            listeners : {
                    'beforequery' : function(combo, record, index) {
                        var MRRowId = Ext.getCmp('txtAllergenType').getValue();
                        Referenceds.baseParams = {
                            MRCATRowId : MRRowId
                        };
                        
                    }
            }
    });
    
    var OrderAllergyMaintain = new Ext.form.FormPanel({
        region : 'north',
        id : 'form-viceadmin',
        labelAlign : 'right',
        height : 125,
        split : true,
        frame : true,
        labelWidth : 100,
        items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                title:'关联过敏原',
                items : [{
                            fieldLabel : 'RowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'RowId'
                        }, {
                            columnWidth : .45, 
                            layout : "form", 
                            items : [{
                                fieldLabel : '过敏原分类',
                                xtype : 'combo',
                                width : 155,
                                id : 'txtAllergenType',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtAllergenType'),
                                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtAllergenType')),
                                store : new Ext.data.Store({
                                    proxy : new Ext.data.HttpProxy({
                                        url : ALGType_QUERY_ACTION_URL
                                    }),
                                    reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [{
                                            name : 'MRCATRowId',
                                            mapping : 'MRCATRowId'
                                        }, {
                                            name : 'MRCATDesc',
                                            mapping : 'MRCATDesc'
                                        }])
                                    }),
                                mode : 'remote',
                                shadow : false,
                                pageSize : Ext.BDP.FunLib.PageSize.Combo,
                                listWidth : 250,
                                forceSelection : true,
                                selectOnFocus : false,
                                triggerAction : 'all',
                                displayField : 'MRCATDesc',
                                valueField : 'MRCATRowId',
                                listeners : {
                                    'select' : function(combo, record, index) {
                                        var MRRowId = Ext.getCmp('txtAllergenType').getValue();
                                        Referenceds.baseParams = {
                                            MRCATRowId : MRRowId
                                        };
                                        Ext.getCmp("txtAllergen").reset();
                                    }
                                
                                
                            }
                        }]
                    }, {
                            columnWidth : .45,
                            layout : "form",
                            items : [txtAllergen]
                        }]
            }]
        }],
        buttonAlign : 'center',
        buttons : [{
            id : 'btn_AddOrderAllergy',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderAllergy'),
            text : '添加',
            iconCls : 'icon-add',
            width : 60,
            handler : function() {
                if (arcimrowid!=""){
                    if (Ext.getCmp("txtAllergen").getValue()!="")
                    {
                        if (!OrderAllergyList.selModel.hasSelection())
                        {
                            AddOrderAllergyFun()
                        }
                        else
                        {
                            Ext.Msg.show({
                                title:'提示',
                                msg:"请先重置，不要选中已关联的过敏原列表!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                            return;
                        }
                        
                    }
                    else
                    {
                        Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择过敏原!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                            return;
                        
                    }
                    
                    
                }
                else{
                    Ext.Msg.show({
                                title:'提示',
                                msg:"请选择一条医嘱项!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
                }
            }
        }, {
            id : 'btn_EditOrderAllergy',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderAllergy'),
            text : '修改',
            iconCls : 'icon-update',
            width : 60,
            handler : function() {
                if (arcimrowid!=""){
                    EditOrderAllergy();
                }
                else{
                        Ext.Msg.show({
                                title:'提示',
                                msg:"请选择一条医嘱项!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                         return;
                    }
            }
        }, {
            id : 'DeleteOrderAllergy_del_btn',
            disabled :Ext.BDP.FunLib.Component.DisableFlag('DeleteOrderAllergy_del_btn'),
            text : '删除',
            iconCls : 'icon-delete',
            width : 60,
            handler : function() {
                if (arcimrowid!=""){
                    DeleteOrderAllergy();
                }
                else{
                    Ext.Msg.show({
                                title:'提示',
                                msg:"请选择一条医嘱项!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
                }
            }
        }, {
            id : 'RefreshAllergy_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('RefreshAllergy_btn'),
            text : '重置',
            iconCls : 'icon-refresh',
            handler : function() {
                resetAllergyForUpdate()
            }
        }]
    });
 
    var AllergyPaging = new Ext.PagingToolbar({
                pageSize : 20,
                store : OrderAllergyStore,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
                emptyMsg : "没有记录",
                plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                   "change" : function(t, p) {
                        pagesize_pop = this.pageSize;
                    }
                }
            });
    var AllergySm = new Ext.grid.CheckboxSelectionModel({
                singleSelect : true,
                checkOnly : false,
                width : 20
    });

    // create the OrderAliasList
    var OrderAllergyList = new Ext.grid.GridPanel({
                id : 'OrderAllergyList',
                region : 'center',
                width : 700,
                height : 800,
                closable : true,
                store : OrderAllergyStore,
                trackMouseOver : true,
                columns : [AllergySm, {
                            header : 'ALGRowId',
                            width : 80,
                            sortable : true,
                            dataIndex : 'ALGRowId',
                            hidden : true
                        
                        },{
                            header : 'MRCATTag',
                            width : 80,
                            sortable : true,
                            dataIndex : 'MRCATTag',
                            hidden : true
                        },{
                            header : 'Table',
                            width : 80,
                            sortable : true,
                            dataIndex : 'Table',
                            hidden : true
                        }, {
                            header : '过敏原',
                            width : 80,
                            sortable : true,
                            dataIndex : 'AllergyDesc'
                        }, {
                            header : '过敏原rowid',
                            width : 80,
                            sortable : true,
                            dataIndex : 'ShowRowId',
                            hidden : true
                        }],
                stripeRows : true,
                sm : new Ext.grid.RowSelectionModel({
                    singleSelect : true,
                    listeners : {
                        rowselect : function(sm, row, rec) {
                        }
                    }
                }),
                columnLines : true, 
                stateful : true,
                viewConfig : {
                    forceFit : true
                },
                bbar : AllergyPaging,
                stateId : 'OrderAliasList'
            });
        //Ext.BDP.FunLib.ShowUserHabit(OrderAllergyList,"User.ARCItemAllergy");
        
    OrderAllergyList.on("rowclick", function(OrderAllergyList, rowIndex, e) {
        var record_OrderAllergy = OrderAllergyList.getSelectionModel().getSelected();
        RowId = record_OrderAllergy.data['AllergyRowId'];
        Ext.getCmp("txtAllergen").reset();
        Ext.getCmp("txtAllergenType").reset();
        
        /// tag 标签
        var MRTag = record_OrderAllergy.data['MRCATTag'];
        Referenceds.baseParams = {
                MRCATRowId:"",
                Tag : MRTag
            };
            
        Ext.getCmp("txtAllergen").setRawValue(record_OrderAllergy.data['AllergyDesc']);
        Ext.getCmp("txtAllergen").setValue(record_OrderAllergy.data['ShowRowId']);
        
    });      
 
    
    var AllergyJPanel=new Ext.Panel({
            layout:'border',
            title:"关联过敏原",
            items:[OrderAllergyMaintain,OrderAllergyList]
    });
    
    //////////////////////////////////////弹窗 过敏原 ///////////////////////////////////////
    var winOrderAllergyStore = new Ext.data.Store({
        proxy : new Ext.data.HttpProxy({
                url : Allergy_ACTION_URL
        }),
        reader : new Ext.data.JsonReader({
                totalProperty : 'total',
                root : 'data',
                successProperty : 'success'
            },  [{
                    name : 'ALGRowId',
                    mapping : 'ALGRowId',
                    type : 'string'
            }, {
                    name:'ShowRowId',
                    mapping:'ShowRowId',
                    type:'string'
            },{
                    name : 'MRCATTag',
                    mapping : 'MRCATTag',
                    type : 'string'
            },{
                    name : 'Table',
                    mapping : 'Table',
                    type : 'string'
            }, {
                    name : 'AllergyDesc',
                    mapping : 'AllergyDesc',
                    type : 'string'
            },{
                    name:'AllergyDR',
                    mapping:'AllergyDR',
                    type:'string'
            } 
        ])
    });
    var winAllergyPaging = new Ext.PagingToolbar({
                pageSize : 20,
                store : winOrderAllergyStore,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
                emptyMsg : "没有记录",
                plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                   "change" : function(t, p) {
                        pagesize_pop = this.pageSize;
                    }
                }
            });
    //  弹窗 ,创建 过敏原表格
    var winOrderAllergyList = new Ext.grid.GridPanel({
                id : 'winOrderAllergyList',
                region : 'center',
                width : 700,
                height : 800,
                closable : true,
                store : winOrderAllergyStore,
                trackMouseOver : true,
                columns : [AllergySm, {
                            header : 'ALGRowId',
                            width : 80,
                            sortable : true,
                            dataIndex : 'ALGRowId',
                            hidden : true
                        }, {
                            header:'AllergyDR',
                            width:80,
                            sortable : true,
                            dataIndex:'AllergyDR',
                            hidden : true
                        
                        },{
                            header : 'MRCATTag',
                            width : 80,
                            sortable : true,
                            dataIndex : 'MRCATTag',
                            hidden : true
                        },{
                            header : 'Table',
                            width : 80,
                            sortable : true,
                            dataIndex : 'Table',
                            hidden : true
                        }, {
                            header : '过敏原',
                            width : 80,
                            sortable : true,
                            dataIndex : 'AllergyDesc'
                        },{
                            header : '过敏原rowid',
                            width : 80,
                            sortable : true,
                            dataIndex : 'ShowRowId',
                            hidden : true
                        }],
                stripeRows : true,
                sm : new Ext.grid.RowSelectionModel({
                    singleSelect : true,
                    listeners : {
                                rowselect : function(sm, row, rec) {
                            }
                        }
                }),
                columnLines : true,  
                stateful : true,
                viewConfig : {
                    forceFit : true
                },
                bbar : winAllergyPaging,
                stateId : 'winOrderAliasList'
            });
      //////////////////////////////弹出窗口的操作：点击医嘱项过敏原/////////////////////////////////////////
    winOrderAllergyList.on("rowclick", function(winOrderAllergyList, rowIndex, e) {
        var record_winOrderAllergy = winOrderAllergyList.getSelectionModel().getSelected();
        RowId = record_winOrderAllergy.data['AllergyRowId'];
        
        Ext.getCmp('txtAllergenType1').setValue(record_winOrderAllergy.data['MRCATTag'])
        Referenceds.baseParams = {
            MRCATRowId : record_winOrderAllergy.data['MRCATTag']
        };
        
        Ext.getCmp("txtAllergen1").setValue(record_winOrderAllergy.data['ShowRowId']);
        Ext.getCmp("txtAllergen1").setRawValue(record_winOrderAllergy.data['AllergyDesc']);
    
        Referenceds.load({
             params:{
                desc : record_winOrderAllergy.data['AllergyDesc']
             }
        });
    });
    
    var wintxtAllergen = new Ext.BDP.Component.form.ComboBox({
            fieldLabel : '<font color=red>*</font>过敏原',
            width : 155,
            allowBlank : false,
            id : 'txtAllergen1',
            hiddenName:'wintxtAllergen2',
            readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtAllergen1'),
            style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtAllergen1')),
            store : Referenceds,
            triggerAction:'query', 
            forceSelection: true,
            selectOnFocus:false,
            pageSize:Ext.BDP.FunLib.PageSize.Combo,
            minChars:0,
            loadByIdParam : 'rowid',
            listWidth:250,
            queryParam : 'desc',
            displayField : 'AllergyDesc',
            valueField : 'RowId',
            listeners : {
                    'beforequery' : function(combo, record, index) {
                        var MRRowId = Ext.getCmp('txtAllergenType1').getValue();
                        Referenceds.baseParams = {
                            MRCATRowId : MRRowId
                        };
                        
                    }
            }   
    });
    
    var winOrderAllergyMaintain = new Ext.form.FormPanel({
        region : 'north',
        id : 'winOrderAllergyMaintain',
        labelAlign : 'right',
        height : 125,
        split : true,
        frame : true,
        labelWidth : 100,
        items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                title:'关联过敏原',
                items : [{
                            fieldLabel : 'RowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'RowId'
                        }, {
                            columnWidth : .45, 
                            layout : "form",  
                            items : [{
                                fieldLabel : '过敏原分类',
                                xtype : 'combo',
                                width : 155,
                                id : 'txtAllergenType1',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtAllergenType1'),
                                style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtAllergenType1')),
                                store : new Ext.data.Store({
                                        proxy : new Ext.data.HttpProxy({
                                                        url : ALGType_QUERY_ACTION_URL
                                                    }),
                                            reader : new Ext.data.JsonReader({
                                                        totalProperty : 'total',
                                                        root : 'data',
                                                        successProperty : 'success'
                                                    }, [{
                                                                name : 'MRCATRowId',
                                                                mapping : 'MRCATRowId'
                                                            }, {
                                                                name : 'MRCATDesc',
                                                                mapping : 'MRCATDesc'
                                                            }])
                                            }),
                                            mode : 'remote',
                                            shadow : false,
                                            pageSize : Ext.BDP.FunLib.PageSize.Combo,
                                            listWidth : 250,
                                            forceSelection : true,
                                            selectOnFocus : false,
                                            triggerAction : 'all',
                                            displayField : 'MRCATDesc',
                                            valueField : 'MRCATRowId',
                                            listeners : {
                                                'select' : function(combo, record, index) {
                                                    var MRRowId = Ext.getCmp('txtAllergenType1').getValue();
                                                    Referenceds.baseParams = {
                                                        MRCATRowId : MRRowId
                                                    };
                                                    Ext.getCmp("txtAllergen1").reset();
                                                }
                                            }
                                        }]
                        }, {
                            columnWidth : .45,
                            layout : "form",
                            items : [wintxtAllergen]
                        }]
                }]
        }],
        buttonAlign : 'center',
        buttons : [{
            id : 'btn_AddOrderAllergy1',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderAllergy1'),
            text : '添加',
            iconCls : 'icon-add',
            width : 60,
            handler : function() {
                    if (Ext.getCmp("txtAllergen1").getRawValue()==""){
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"过敏原不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                        return;
                    }
                    
                    var validateflag = true;
                    winOrderAllergyStore.each(function(record){
                        if(Ext.getCmp("txtAllergen1").getRawValue()==record.get('AllergyDesc')){
                            validateflag = false;
                        }
                    }, this); //验证新增数据是否存在
                    if(!validateflag)
                    {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"该记录已经存在!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                        })
                        return;
                    }
                    
                    var _record = new Ext.data.Record({
                        'ALGRowId':'',
                        'ShowRowId':Ext.getCmp("txtAllergen1").getValue(),
                        'MRCATTag':Ext.getCmp("txtAllergenType1").getValue(),
                        'AllergyDR':Ext.getCmp("txtAllergen1").getValue(), 
                        'AllergyDesc': Ext.getCmp("txtAllergen1").getRawValue() 
                    });
                    winOrderAllergyList.stopEditing();
                    winOrderAllergyStore.insert(0,_record);        
                    
                    resetAllergyForAdd();
                    winOrderAllergyStore.totalLength=Ext.getCmp("winOrderAllergyList").getStore().getTotalCount()+1
                    Ext.getCmp("winOrderAllergyList").getBottomToolbar().bind(winOrderAllergyStore)
                }
        }, {
            id : 'btn_EditOrderAllergy1',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderAllergy1'),
            text : '修改',
            iconCls : 'icon-update',
            width : 60,
            handler : function() {
                if(winOrderAllergyList.selModel.hasSelection()){
                        
                        if (Ext.getCmp("txtAllergen1").getRawValue()==""){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"过敏原不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            return;
                        }
                        
                        var myrecord = winOrderAllergyList.getSelectionModel().getSelected();
                        var validateflag = true;
                        winOrderAllergyStore.each(function(record){
                            if (myrecord!=record) 
                            {
                                if(Ext.getCmp("txtAllergen1").getRawValue()==record.get('AllergyDesc')){
                                    validateflag = false;
                                }
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                        
                        myrecord.set('MRCATTag',Ext.getCmp('txtAllergenType1').getValue());
                        myrecord.set('AllergyDesc',Ext.getCmp('txtAllergen1').getRawValue());
                        myrecord.set('AllergyDR',Ext.getCmp('txtAllergen1').getValue());
                        myrecord.set('ShowRowId',Ext.getCmp('txtAllergen1').getValue());
                        resetAllergyForAdd();
                }
                else{
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:"请先选中医嘱项过敏原!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                    }
            }
        }, {
            id : 'winDeleteOrderAllergy_del_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('winDeleteOrderAllergy_del_btn'),
            text : '删除',
            iconCls : 'icon-delete',
            width : 60,
            handler : function() {
                    if(winOrderAllergyList.selModel.hasSelection()){
                       var gsm = winOrderAllergyList.getSelectionModel(); 
                       var rows = gsm.getSelections(); 
                      
                        winOrderAllergyStore.remove(rows[0]);
                        resetAllergyForAdd()
                        winOrderAllergyStore.totalLength=Ext.getCmp("winOrderAllergyList").getStore().getTotalCount()-1
                        Ext.getCmp("winOrderAllergyList").getBottomToolbar().bind(winOrderAllergyStore)
                        
                  }
                  else{
                       Ext.Msg.show({
                                    title:'提示',
                                    msg:"请先选中医嘱项过敏原!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                    }
                }
        }, {
            id : 'RefreshAllergy_btn1',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('RefreshAllergy_btn1'),
            text : '重置',
            iconCls : 'icon-refresh',
            handler : function() {
                resetAllergyForAdd()
            }
        }]
    });
    
    var winAllergyJPanel=new Ext.Panel({
            layout:'border',
            title:"关联过敏原",
            items:[winOrderAllergyMaintain,winOrderAllergyList]
    });
   */   
    
    /////////////////////////////////////医嘱项接收科室///////////////////////////////////////////////
    
   
    
  //////////////////////////////添加 医嘱项接收科室的功能函数////////////////////////////////////////
    var AddReceiveLoc=function(){
            
            if (Ext.getCmp('recloc').getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"接收科室不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                             });
                 Ext.getCmp("recloc").focus();
                 return;
            }              
            if (Ext.getCmp("RecLocDateFrom").getValue()=="") {
                  Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                             });
                 Ext.getCmp("RecLocDateFrom").focus();
                 return;
            }
            if (Ext.getCmp("RecLocDateFrom").getValue()!="" & Ext.getCmp("RecLocDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("RecLocDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("RecLocDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                    Ext.Msg.show({
                                    title : '提示',
                                    msg : '开始日期不能大于结束日期!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                    return;
                }
               
            }
            if (Ext.getCmp("timefrom").getValue() != "" && Ext.getCmp("timeto").getValue() != "") {
                if (Ext.getCmp("timefrom").getValue() > Ext.getCmp("timeto").getValue()) {
                    Ext.Msg.show({
                                    title : '提示',
                                    msg : '开始时间不能大于结束时间!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                    return;
                }
            }
            var ARCRLClinicType=Ext.getCmp('ARCRLClinicTypeF').getValue()
            var AddReceiveLocset=arcimrowid+"^"+Ext.getCmp('patloc').getValue()+"^"+Ext.getCmp('recloc').getValue()+"^"+Ext.getCmp('defaultprior').getValue()+"^"+Ext.getCmp("RecLocDateFrom").getRawValue()+"^"+Ext.getCmp("RecLocDateTo").getRawValue()+"^"+Ext.getCmp("timefrom").getValue()+"^"+Ext.getCmp("timeto").getValue()+"^"+Ext.getCmp("defaultflag").getValue()+"^^"+Ext.getCmp("ARCRLCTHospitalDR").getValue()+"^"+ARCRLClinicType;
            Ext.Ajax.request({
                url:AddReceiveLoc_ACTION_URL,
                method:'POST',
                params:{
                    'SaveDataStr':AddReceiveLocset   //添加医嘱项接收科室
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                            OrderRecLocDS.load({ 
                                                params:{start : 0, limit : pagesize_main, ParRef:arcimrowid},
                                                callback: function(r, options, success){
                                                    if(success){
                                                    }
                                                    else{
                                                         Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:jsonData.info,
                                                                        icon:Ext.Msg.ERROR,
                                                                        buttons:Ext.Msg.OK
                                                                    });
                                                        }
                                                     }
                                                });  
                                                resetPatLocPanelForUpdate()
                                                
                                    }
                            });                         
                        }else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                }
                            }else{
                                  Ext.Msg.show({
                                                title:'提示',
                                                msg:"医嘱项接收科室加载失败!",
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                            }
                         }
                    })
            };  
/********************************************批量添加 医嘱项 接收科室 数据*********************************/
    var MultiAddRecLoc=function(rowid){
             var ARCRecLocCount=winOrderRecLocDS.getCount();
             if (ARCRecLocCount!=0){
                    AddRecLocStr="";
                    winOrderRecLocDS.each(function(record){
                        if(AddRecLocStr!="") AddRecLocStr = AddRecLocStr+"*";
                        var datefrom2=record.get('ARCRLDateFrom');
                        var dateto2=record.get('ARCRLDateTo');
                        
                        AddRecLocStr = AddRecLocStr+record.get('ARCRLOrdLocDR')+'^'+record.get('ARCRLRecLocDR')+'^'+record.get('ARCRLOrderPriorityDR')+'^'+record.get('ARCRLDefaultFlag')+'^'+record.get('ARCRLTimeFrom')+'^'+record.get('ARCRLTimeTo')+'^'+datefrom2+'^'+dateto2;
                    }, this);
                }
                else{
                        AddRecLocStr="";
                }
        Ext.Ajax.request({
            url:MultiAddRecLoc_URL,
            method:'POST',
            params:{
                'rowid':rowid,
                'AddRecLocStr':AddRecLocStr
            }   
        });  
    }       
            
    ///往后台保存
/**********************************************修改医嘱项接收科室 **************************************/
    var UpOrdRecLoc=function(){
        var editreclocset="";
        var records = OrderRecLocList.selModel.getSelections();
        if (records.length == 0) 
        {
            Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项接收科室!",
                            icon:Ext.Msg.INFO,
                            buttons:Ext.Msg.OK
                    });
            return;
        }
        
        if (records.length>0){
            var RowId=records[0].get('ARCRLRowId')
            if (Ext.getCmp('recloc').getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"接收科室不能为空!",
                                icon:Ext.Msg.INFO,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("recloc").focus();
                 return;
            }              
            if (Ext.getCmp("RecLocDateFrom").getValue()=="") {
                  Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空,请输入!",
                                icon:Ext.Msg.INFO,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("RecLocDateFrom").focus();
                 return;
            }
            if (Ext.getCmp("RecLocDateFrom").getValue()!="" & Ext.getCmp("RecLocDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("RecLocDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("RecLocDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                    Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能大于结束日期!",
                                icon:Ext.Msg.INFO,
                                buttons:Ext.Msg.OK
                            });
                    return;
                }
                
            }
            if (Ext.getCmp("timefrom").getValue() != "" && Ext.getCmp("timeto").getValue() != "") {
                if (Ext.getCmp("timefrom").getValue() > Ext.getCmp("timeto").getValue()) {
                    Ext.Msg.show({
                                    title : '提示',
                                    msg : '开始时间不能大于结束时间!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                    return;
                }
            }
            editreclocset=RowId+"^"+Ext.getCmp('patloc').getValue()+"^"+Ext.getCmp('recloc').getValue()+"^"+Ext.getCmp('defaultprior').getValue()+"^"+Ext.getCmp("RecLocDateFrom").getRawValue()+"^"+Ext.getCmp("RecLocDateTo").getRawValue()+"^"+Ext.getCmp("timefrom").getValue()+"^"+Ext.getCmp("timeto").getValue()+"^"+Ext.getCmp("defaultflag").getValue()+"^^"+Ext.getCmp("ARCRLCTHospitalDR").getValue()+"^"+Ext.getCmp("ARCRLClinicTypeF").getValue();           
            Ext.Ajax.request({
                url:UpdateRecLoc_ACTION_URL,
                method:'POST',
                params:{
                    'editordrecloc':editreclocset    
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:jsonData.info,
                                        icon:Ext.Msg.INFO,
                                        buttons:Ext.Msg.OK,
                                        fn:function(btn){
                                            OrderRecLocDS.load({ 
                                              params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                              callback: function(r, options, success){
                                                if(success){
                                                }
                                                else{
                                                     Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:jsonData.info,
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                    }
                                                 }
                                    }); 
                                        resetPatLocPanelForUpdate()                             
                                        
                                    }
                                });                         
                            }else{
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                }
                      }else{
                          Ext.Msg.show({
                                        title:'提示',
                                        msg:"医嘱项接收科室修改失败!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                        }
                 }
            })
        }
    };
    ////////////////  删除 tabpanel 医嘱项接收科室数据 ///////////////////////////////////////
    var DeleteOrdRecLoc=function(){
         if(OrderRecLocList.selModel.hasSelection()){
           var gsm = OrderRecLocList.getSelectionModel(); 
           var rows = gsm.getSelections(); 
           var records = OrderRecLocList.selModel.getSelections();
           Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
           if(btn=='yes'){
                var DelRecLocRowid=rows[0].get('ARCRLRowId');
                if(DelRecLocRowid==""){  
             
                }
                else{
                    if (arcimrowid=="") { 
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                        return;
                }
                
                if (records.length == 0) 
                { 
                    Ext.Msg.show({
                                    title:'提示',
                                    msg:"请先选择一条医嘱项接收科室!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                });
                    return;
                }       
                else{
                var ReclocRowid=records[0].get('ARCRLRowId');
              
                            Ext.Ajax.request({
                                url:DeleteReceiveLoc_ACTION_URL,
                                method:'POST',
                                params:{
                                    'rowid':ReclocRowid    
                                },
                                callback:function(options, success, response){
                                    if(success){
                                        OrderRecLocDS.load({ 
                                                    params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                                    callback: function(r, options, success){
                                                        if(success){
                                                        }
                                                        else{
                                                             Ext.Msg.show({
                                                                            title:'提示',
                                                                            msg:"医嘱项接收科室加载失败!",
                                                                            icon:Ext.Msg.ERROR,
                                                                            buttons:Ext.Msg.OK
                                                                        });
                                                            }
                                                     }
                                            });  
                                            resetPatLocPanelForUpdate()
                                            
                                }else{
                                     Ext.Msg.show({
                                                    title:'提示',
                                                    msg:"医嘱项接收科室删除失败!",
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                    }
                                }
                         })
                     }
                }
            }
        });
   }
}

/////////////////删除 window弹窗的  医嘱项接收科室//////////////////////////////////////////

    var winDeleteOrdRecLoc=function(){
         if(winOrderRecLocList.selModel.hasSelection()){
           var gsm = winOrderRecLocList.getSelectionModel(); 
           var rows = gsm.getSelections(); 
         
            var DelRecLocRowid=rows[0].get('ARCRLRowId');
            if(DelRecLocRowid==""){  
                winOrderRecLocDS.remove(rows[0]);
                resetPatLocPanelForAdd()
                winOrderRecLocDS.totalLength=Ext.getCmp("winOrderRecLocList").getStore().getTotalCount()-1
                Ext.getCmp("winOrderRecLocList").getBottomToolbar().bind(winOrderRecLocDS)
             }
             
        }
        else{
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项接收科室!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }       
    }

    //////////////////////////////////// 医嘱项接收科室存储数据源/////////////////////////////////////
     var OrderRecLocDS  = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCRecLoc_ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{name: 'ARCRLRowId', mapping:'ARCRLRowId',type: 'string'},
           { name: 'ARCRLOrdLocDesc', mapping:'ARCRLOrdLocDesc',type: 'string'},
           { name: 'ARCRLRecLocDesc', mapping:'ARCRLRecLocDesc',type: 'string'},
           { name: 'ARCRLCTHospitalDesc', mapping:'ARCRLCTHospitalDesc',type: 'string'},
           { name: 'ARCRLOrderPriorityDesc', mapping:'ARCRLOrderPriorityDesc',type: 'string'},
           { name: 'ARCRLDefaultFlag', mapping:'ARCRLDefaultFlag',type: 'string'},
           { name: 'ARCRLTimeFrom', mapping:'ARCRLTimeFrom',type: 'string'},
           { name: 'ARCRLTimeTo', mapping:'ARCRLTimeTo',type: 'string'},
           { name: 'ARCRLDateFrom',mapping:'ARCRLDateFrom',type: 'string'},
           { name: 'ARCRLDateTo',mapping:'ARCRLDateTo', type: 'string'},
           {name: 'ARCRLOrdLocDR', mapping:'ARCRLOrdLocDR',type: 'string'},
           {name: 'ARCRLRecLocDR', mapping:'ARCRLRecLocDR',type: 'string'},
           { name: 'ARCRLCTHospitalDR', mapping:'ARCRLCTHospitalDR',type: 'string'},
           {name: 'ARCRLOrderPriorityDR', mapping:'ARCRLOrderPriorityDR',type: 'string'},
           {name: 'ARCRLClinicType', mapping:'ARCRLClinicType',type: 'string'}
           
         ])
     });
     
    OrderRecLocDS.on('beforeload',function() {
        var gsm = OrderRecLocList.getSelectionModel(); 
        var rows = gsm.getSelections(); 
        Ext.apply(OrderRecLocDS.lastOptions.params, {
            ParRef:arcimrowid
        });
    },this);
    
    var RecLocPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderRecLocDS,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
    var RecLocSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    //  医嘱项接收科室tab 页面的 grid
    var OrderRecLocList = new Ext.grid.GridPanel({
        id:'OrderRecLocList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: OrderRecLocDS,
        trackMouseOver: true,
        columns: [
                RecLocSm,
                { header: '病人科室', width: 160, sortable: true, dataIndex: 'ARCRLOrdLocDesc' ,renderer : Ext.BDP.FunLib.Component.GirdTipShow},
                { header: '接收科室', width: 160, sortable: true, dataIndex: 'ARCRLRecLocDesc' ,renderer : Ext.BDP.FunLib.Component.GirdTipShow},
                { header: '医院', width: 160, sortable: true, dataIndex: 'ARCRLCTHospitalDesc' ,renderer : Ext.BDP.FunLib.Component.GirdTipShow},
                { header: '医嘱优先级', width: 80, sortable: true, dataIndex: 'ARCRLOrderPriorityDesc' },
                { header: '默认', width: 50, sortable: true, dataIndex: 'ARCRLDefaultFlag',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: '开始日期', width: 90, sortable: true, dataIndex: 'ARCRLDateFrom' },
                { header: '结束日期', width: 90, sortable: true, dataIndex: 'ARCRLDateTo' },
                { header: '开始时间', width: 80, sortable: true,dataIndex: 'ARCRLTimeFrom'},
                { header: '结束时间', width: 80, sortable: true, dataIndex: 'ARCRLTimeTo'}, 
                { header: 'ARCRLRowId', width: 30, sortable: true, dataIndex: 'ARCRLRowId', hidden:true},
                { header: '病人科室Dr', width: 30, sortable: true, dataIndex: 'ARCRLOrdLocDR', hidden:true},
                { header: '接收科室Dr', width: 30, sortable: true, dataIndex: 'ARCRLRecLocDR', hidden:true},
                { header: '医院Dr', width: 30, sortable: true, dataIndex: 'ARCRLCTHospitalDR', hidden:true},
                { header: '医嘱优先级Dr', width: 30, sortable: true, dataIndex: 'ARCRLOrderPriorityDR', hidden:true},
        { header: '就诊类型', width: 80, sortable: true, dataIndex: 'ARCRLClinicType'}
                
             ],
        stripeRows: true,
        viewConfig : {
                    forceFit : true
                },
        columnLines : true,  
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                  rowselect: function(sm, row, rec) {                            
                }
            }
         }),
        stateful: true,
        bbar:RecLocPaging ,
        stateId: 'OrderRecLocList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(OrderRecLocList,"User.ARCItmRecLoc");
    
    OrderRecLocList.on("rowclick",function(OrderRecLocList,rowIndex,e){
            var record = OrderRecLocList.getSelectionModel().getSelected();
            RowId=record.data['ARCRLRowId'];    //表ARC_ItmRecLoc的ARCRL_RowId
            Ext.getCmp('patloc').setValue(record.data['ARCRLOrdLocDR']);  //病人科室Dr
            Ext.getCmp("patloc").setRawValue(record.data['ARCRLOrdLocDesc']);
            Ext.getCmp('recloc').setValue(record.data['ARCRLRecLocDR']);  //接收科室Dr
            Ext.getCmp("recloc").setRawValue(record.data['ARCRLRecLocDesc']);
            Ext.getCmp('ARCRLCTHospitalDR').setValue(record.data['ARCRLCTHospitalDR']);  //医院Dr
            Ext.getCmp("ARCRLCTHospitalDR").setRawValue(record.data['ARCRLCTHospitalDesc']);
            Ext.getCmp('defaultprior').setValue(record.data['ARCRLOrderPriorityDR']);  //医嘱优先级Dr
            Ext.getCmp('defaultprior').setRawValue(record.data['ARCRLOrderPriorityDesc']);
            Ext.getCmp("RecLocDateFrom").setValue(record.data['ARCRLDateFrom']);
            Ext.getCmp("RecLocDateTo").setValue(record.data['ARCRLDateTo']);
            Ext.getCmp("timefrom").setValue(record.data['ARCRLTimeFrom']);
            Ext.getCmp("timeto").setValue(record.data['ARCRLTimeTo']);
            if (record.data['ARCRLDefaultFlag']=='Y') {
                 Ext.getCmp("defaultflag").setValue("1")
            }
            else {
                 Ext.getCmp("defaultflag").setValue("0")
            }
            Ext.getCmp('ARCRLCTHospitalDR').setValue(record.data['ARCRLCTHospitalDR']);  //医院Dr
            Ext.getCmp("ARCRLCTHospitalDR").setRawValue(record.data['ARCRLCTHospitalDesc']);
            var ARCRLClinicType=record.data['ARCRLClinicType']
            
            //(门诊O,急诊E,住院I,体检H,新生儿N)
            ARCRLClinicType=ARCRLClinicType.replace("门诊","O")
            ARCRLClinicType=ARCRLClinicType.replace("急诊","E")
            ARCRLClinicType=ARCRLClinicType.replace("住院","I")
            ARCRLClinicType=ARCRLClinicType.replace("体检","H")
            ARCRLClinicType=ARCRLClinicType.replace("新生儿","N")
            
            Ext.getCmp("ARCRLClinicTypeF").setValue(ARCRLClinicType);
    }); 
    //////////////////////////tabpanel中的接收科室面板///////////////////////////////////////////
    
    var RecLocformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'接收科室维护',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'80%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '病人科室',
                        id:'patloc',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('patloc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('patloc')),
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        listWidth:250,
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc',
                        listeners:{
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            tablename:Ext.BDP.FunLib.TableName,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        id:'RecLocDateFrom',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('RecLocDateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RecLocDateFrom')),
                        name: 'EffDate',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'RecLocDateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('RecLocDateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RecLocDateTo')),
                        name: 'EffDateTo',
                        format:BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    },{
                            xtype : 'combo',
                            listWidth : 250,
                            fieldLabel : '就诊类型',
                            name : 'ARCRLClinicType',
                            id:'ARCRLClinicTypeF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCRLClinicTypeF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCRLClinicTypeF')),
                            hiddenName : 'ARCRLClinicType',
                            allowBlank : true,
                            mode : 'local',
                            store : new Ext.data.SimpleStore({
                                        fields : ['value', 'text'],
                                        data : [
                                                    ['O', '门诊'],
                                                    ['E', '急诊'],
                                                    ['I', '住院'],
                                                    ['H', '体检'],
                                                    ['N', '新生儿']
                                                ]
                                    }),
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            //typeAhead : true,
                            //minChars : 1,
                            valueField : 'value',
                            displayField : 'text'
                        }]
                },{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'80%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>接收科室',
                        id:'recloc',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('recloc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('recloc')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        listWidth:250,
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc'
                    },{
                        xtype : 'timefield',
                        fieldLabel: '开始时间',
                        id:'timefrom',
                        listWidth:180,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('timefrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('timefrom')),
                        format : 'H:i:s',
                        increment: 15
                    },{
                        xtype : 'timefield',
                        fieldLabel: '结束时间',
                        id:'timeto',
                        listWidth:180,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('timeto'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('timeto')),
                        format : 'H:i:s',
                        increment: 15 
                    }]
                },{
                    layout: 'form',
                    columnWidth: '.3',
                    labelWidth:90,
                    border:false,
                    defaults: {anchor:'80%'},
                    items: [{
                        fieldLabel: '医嘱优先级',
                        xtype:'bdpcombo',
                        id:'defaultprior',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultprior'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultprior')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',   
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        minChars: 0,   
                        listWidth:250,
                        valueField:'OECPRRowId',
                        displayField:'OECPRDesc',
                        store:new Ext.data.JsonStore({
                                     url:Priority_QUERY_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['OECPRRowId','OECPRCode','OECPRDesc']
                              }) 
                    },{
                        xtype:'checkbox',
                        //hideLabel:true,
                        fieldLabel:'默认接收科室',
                        id:'defaultflag',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultflag'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultflag')),
                        inputValue:'Y'
                    },{
                        fieldLabel: '医院',
                        xtype:'bdpcombo',
                        id:'ARCRLCTHospitalDR',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCRLCTHospitalDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCRLCTHospitalDR')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',  
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        minChars: 0,   
                        listWidth:250,
                        valueField:'HOSPRowId',
                        displayField:'HOSPDesc',
                        store:new Ext.data.JsonStore({
                            url:Hosp_QUERY_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['HOSPRowId','HOSPDesc']
                        })
                    }]
                }]
            }]}
            ],
            
        buttonAlign:'center',
        buttons:[{
                    id:'btn_AddReceiveLoc',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddReceiveLoc'),
                    text:'添加',
                    iconCls : 'icon-add',
                    handler:function(){
                        var DefaultValue=""
                        if (arcimrowid!=""){
                            AddReceiveLoc()
                        }
                        else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                             return;
                        }
                    }
                },{
                    id:'btn_UpOrdRecLoc',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpOrdRecLoc'),
                    text:'修改',
                    iconCls : 'icon-update',
                    handler:function(){
                        if (arcimrowid!=""){
                                UpOrdRecLoc()
                        }
                        else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                             return;
                    }
                }
            },{
                    id:'DeleteOrdRecLoc_del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteOrdRecLoc_del_btn'),
                    text:'删除',
                    iconCls : 'icon-delete',
                    handler:function(){
                        if (arcimrowid!=""){
                            DeleteOrdRecLoc()
                        }
                        else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                             return;
                        }
                    }
            },{
                    id:'btn_SearchOrdRecLoc',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_SearchOrdRecLoc'),
                    text:'搜索',
                    iconCls : 'icon-search',
                    handler:function(){
                        SearchPatLocPanelForUpdate()        
                    }                 
            },{
                    id:'btn_RefreshOrdRecLoc',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshOrdRecLoc'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function(){
                                resetPatLocPanelForUpdate()
                                
                    }                 
                }]          
    }; 
    var ARCItmRecLocJPanel=new Ext.Panel({
        layout:'border',
        title:'接收科室',
        items:[RecLocformDetail,OrderRecLocList]
    });
    
    /// 搜索  修改医嘱页面的接收科室 
    SearchPatLocPanelForUpdate=function(){
    var HospId=Ext.getCmp("ARCRLCTHospitalDR").getValue();
    var PatLoc=Ext.getCmp("patloc").getValue();
    var RecLoc=Ext.getCmp("recloc").getValue();  
    OrderRecLocDS.load({ 
        params:{start : 0, limit : pagesize_main, ParRef:arcimrowid,PatLoc:PatLoc,RecLoc:RecLoc,HospId:HospId},
        callback: function(r, options, success){
            if(success){
            }
            else{
                 Ext.Msg.show({
                                title:'提示',
                                msg:jsonData.info,
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                }
             }
        });   
    }
    
    
    //////////////////// 医嘱项接收科室  弹出窗口的  grid  和formpanel /////////////////////////
    var winOrderRecLocDS  = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCRecLoc_ACTION_URL}),//调用的动作
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{name: 'ARCRLRowId', mapping:'ARCRLRowId',type: 'string'},
           { name: 'ARCRLOrdLocDesc', mapping:'ARCRLOrdLocDesc',type: 'string'},
           { name: 'ARCRLRecLocDesc', mapping:'ARCRLRecLocDesc',type: 'string'},
           { name: 'ARCRLCTHospitalDesc', mapping:'ARCRLCTHospitalDesc',type: 'string'},
           { name: 'ARCRLOrderPriorityDesc', mapping:'ARCRLOrderPriorityDesc',type: 'string'},
           { name: 'ARCRLDefaultFlag', mapping:'ARCRLDefaultFlag',type: 'string'},
           { name: 'ARCRLTimeFrom', mapping:'ARCRLTimeFrom',type: 'string'},
           { name: 'ARCRLTimeTo', mapping:'ARCRLTimeTo',type: 'string'},
           { name: 'ARCRLDateFrom',mapping:'ARCRLDateFrom',type: 'string'},
           { name: 'ARCRLDateTo',mapping:'ARCRLDateTo', type: 'string'},
           {name: 'ARCRLOrdLocDR', mapping:'ARCRLOrdLocDR',type: 'string'},
           {name: 'ARCRLRecLocDR', mapping:'ARCRLRecLocDR',type: 'string'},
           { name: 'ARCRLCTHospitalDR', mapping:'ARCRLCTHospitalDR',type: 'string'},
           {name: 'ARCRLOrderPriorityDR', mapping:'ARCRLOrderPriorityDR',type: 'string'},
           {name: 'ARCRLClinicType', mapping:'ARCRLClinicType',type: 'string'}

         ])
     });
   
    
    var winRecLocPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: winOrderRecLocDS,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })
    var winOrderRecLocList = new Ext.grid.GridPanel({
        id:'winOrderRecLocList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: winOrderRecLocDS,
        trackMouseOver: true,
        columns: [
                RecLocSm,
                { header: '病人科室', width: 160, sortable: true, dataIndex: 'ARCRLOrdLocDesc' ,renderer : Ext.BDP.FunLib.Component.GirdTipShow},
                { header: '接收科室', width: 160, sortable: true, dataIndex: 'ARCRLRecLocDesc',renderer : Ext.BDP.FunLib.Component.GirdTipShow },
                { header: '医院', width: 160, sortable: true, dataIndex: 'ARCRLCTHospitalDesc' ,renderer : Ext.BDP.FunLib.Component.GirdTipShow},
                { header: '医嘱优先级', width: 80, sortable: true, dataIndex: 'ARCRLOrderPriorityDesc' },
                { header: '默认', width: 50, sortable: true, dataIndex: 'ARCRLDefaultFlag',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: '开始日期', width: 90, sortable: true,dataIndex: 'ARCRLDateFrom' },
                { header: '结束日期', width: 90, sortable: true, dataIndex: 'ARCRLDateTo' },
                { header: '开始时间', width: 80, sortable: true,dataIndex: 'ARCRLTimeFrom'},
                { header: '结束时间', width: 80, sortable: true, dataIndex: 'ARCRLTimeTo'},
                { header: 'ARCRLRowId', width: 30, sortable: true, dataIndex: 'ARCRLRowId', hidden:true},
                { header: '病人科室Dr', width: 30, sortable: true, dataIndex: 'ARCRLOrdLocDR', hidden:true},
                { header: '接收科室Dr', width: 30, sortable: true, dataIndex: 'ARCRLRecLocDR', hidden:true},
                { header: '医院Dr', width: 30, sortable: true, dataIndex: 'ARCRLCTHospitalDR', hidden:true},
                { header: '医嘱优先级Dr', width: 30, sortable: true, dataIndex: 'ARCRLOrderPriorityDR', hidden:true},
                { header: '就诊类型', width: 80, sortable: true, dataIndex: 'ARCRLClinicType'}
             ],
        stripeRows: true,
        columnLines : true,  
        viewConfig : {
                    forceFit : true
                },
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                       rowselect: function(sm, row, rec) {                            
                    }
             }
         }),
        stateful: true,
        bbar:winRecLocPaging ,
        stateId: 'winOrderRecLocList'
    });
    /////////////////window 窗口下的 列表选中，加载数据  添加  /////////////////////////////
    winOrderRecLocList.on("rowclick",function(winOrderRecLocList,rowIndex,e){
            var record = winOrderRecLocList.getSelectionModel().getSelected();
            RowId=record.data['ARCRLRowId'];    
            //病人科室 
            Ext.getCmp('patloc1').setValue(record.data['ARCRLOrdLocDR']);   
            Ext.getCmp("patloc1").setRawValue(record.data['ARCRLOrdLocDesc']);
            //接收科室 
            Ext.getCmp('recloc1').setValue(record.data['ARCRLRecLocDR']);  
            Ext.getCmp("recloc1").setRawValue(record.data['ARCRLRecLocDesc']);
            Ext.getCmp('ARCRLCTHospitalDR1').setValue(record.data['ARCRLCTHospitalDR']);  //医院Dr
            Ext.getCmp("ARCRLCTHospitalDR1").setRawValue(record.data['ARCRLCTHospitalDesc']);
            //医嘱优先级 
            Ext.getCmp('defaultprior1').setValue(record.data['ARCRLOrderPriorityDR']);  
            Ext.getCmp('defaultprior1').setRawValue(record.data['ARCRLOrderPriorityDesc']);
            Ext.getCmp("RecLocDateFrom1").setValue(record.data['ARCRLDateFrom']);
            Ext.getCmp("RecLocDateTo1").setValue(record.data['ARCRLDateTo']);
            Ext.getCmp("timefrom1").setValue(record.data['ARCRLTimeFrom']);
            Ext.getCmp("timeto1").setValue(record.data['ARCRLTimeTo']);
            if (record.data['ARCRLDefaultFlag']=='Y') {
                 Ext.getCmp("defaultflag1").setValue("1")
            }
            else {
                 Ext.getCmp("defaultflag1").setValue("0")
            }
            var ARCRLClinicType=record.data['ARCRLClinicType']
            
            //(门诊O,急诊E,住院I,体检H,新生儿N)
            ARCRLClinicType=ARCRLClinicType.replace("门诊","O")
            ARCRLClinicType=ARCRLClinicType.replace("急诊","E")
            ARCRLClinicType=ARCRLClinicType.replace("住院","I")
            ARCRLClinicType=ARCRLClinicType.replace("体检","H")
            ARCRLClinicType=ARCRLClinicType.replace("新生儿","N")

            Ext.getCmp("ARCRLClinicType1F").setValue(ARCRLClinicType);
    });
    
    
    //////////////////////////////////// 医嘱项接收科室   弹窗的  form面板 ///////////////////////////////////////
    var winRecLocformDetail = {
        id:'winRecLocForm',
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'接收科室维护',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'85%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '病人科室',
                        id:'patloc1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('patloc1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('patloc1')),
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        listWidth:250,
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc',
                        listeners:{
                               'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            tablename:Ext.BDP.FunLib.TableName,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                    }})
                                
                                }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        id:'RecLocDateFrom1',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('RecLocDateFrom1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RecLocDateFrom1')),
                        name: 'EffDate',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'RecLocDateTo1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('RecLocDateTo1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RecLocDateTo1')),
                        name: 'EffDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    },{
                            xtype : 'combo',
                            listWidth : 250,
                            fieldLabel : '就诊类型',
                            name : 'ARCRLClinicType1',
                            id:'ARCRLClinicType1F',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCRLClinicType1F'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCRLClinicType1F')),
                            hiddenName : 'ARCRLClinicType1',
                            allowBlank : true,
                            mode : 'local',
                            store : new Ext.data.SimpleStore({
                                        fields : ['value', 'text'],
                                        data : [
                                                    ['O', '门诊'],
                                                    ['E', '急诊'],
                                                    ['I', '住院'],
                                                    ['H', '体检'],
                                                    ['N', '新生儿']
                                                ]
                                    }),
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            //typeAhead : true,
                            //minChars : 1,
                            valueField : 'value',
                            displayField : 'text'
                        }]
                },{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'85%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>接收科室',
                        hiddenName:'ARCRLRecLocDR',
                        id:'recloc1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('recloc1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('recloc1')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        listWidth:250,
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc'
                    },{
                        xtype : 'timefield',
                        fieldLabel: '开始时间',
                        id:'timefrom1',
                        listWidth:180,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('timefrom1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('timefrom1')),
                        format : 'H:i:s',
                        increment: 15
                    },{
                        xtype : 'timefield',
                        fieldLabel: '结束时间',
                        id:'timeto1',
                        listWidth:180,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('timeto1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('timeto1')),
                        format : 'H:i:s',
                        increment: 15 
                    }]
                },{
                    layout: 'form',
                    columnWidth: '.3',
                    border:false,
                    labelWidth:100,
                    defaults: {anchor:'85%'},
                    items: [{
                        fieldLabel: '医嘱优先级',
                        xtype:'bdpcombo',
                        id:'defaultprior1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultprior1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultprior1')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',  
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        minChars: 0,   
                        listWidth:250,
                        valueField:'OECPRRowId',
                        displayField:'OECPRDesc',
                        store:new Ext.data.JsonStore({
                            url:Priority_QUERY_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['OECPRRowId','OECPRCode','OECPRDesc']
                    })
                    },{
                        xtype:'checkbox',
                        fieldLabel:'默认接收科室',
                        id:'defaultflag1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultflag1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultflag1')),
                        inputValue:'Y'
                    },{
                        fieldLabel: '医院',
                        xtype:'bdpcombo',
                        id:'ARCRLCTHospitalDR1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCRLCTHospitalDR1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCRLCTHospitalDR1')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',  
                        pageSize:Ext.BDP.FunLib.PageSize.Combo,  
                        minChars: 0,   
                        listWidth:250,
                        valueField:'HOSPRowId',
                        displayField:'HOSPDesc',
                        store:new Ext.data.JsonStore({
                            url:Hosp_QUERY_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['HOSPRowId','HOSPDesc']
                        })
                    }]
                }]
            }]}],
                
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddReceiveLoc1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddReceiveLoc1'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    var DefaultValue=""
                                     if (Ext.getCmp("defaultflag1").getValue()==""){
                                        DefaultValue="N"
                                     }
                                     else if (Ext.getCmp("defaultflag1").getValue()==true){
                                        DefaultValue="Y"
                                     }
                                     if (Ext.getCmp("recloc1").getValue()==""){
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"接收科室不能为空!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            return ;
                                     }
                                    if (Ext.getCmp("RecLocDateFrom1").getValue()==""){
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"开始日期不能为空!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            return ;
                                     }
                                     
                                     if (Ext.getCmp("RecLocDateFrom1").getValue()!="" & Ext.getCmp("RecLocDateTo1").getValue()!="") {
                                        var fromdate=Ext.getCmp("RecLocDateFrom1").getValue().format("Ymd");
                                        var todate=Ext.getCmp("RecLocDateTo1").getValue().format("Ymd");
                                        if (fromdate > todate) {
                                            Ext.Msg.show({
                                                            title : '提示',
                                                            msg : '开始日期不能大于结束日期!',
                                                            minWidth : 200,
                                                            icon : Ext.Msg.ERROR,
                                                            buttons : Ext.Msg.OK
                                                        });
                                            return;
                                        }
                                    }
                                    
                                    if (Ext.getCmp("timefrom1").getValue() != "" && Ext.getCmp("timeto1").getValue() != "") {
                                        if (Ext.getCmp("timefrom1").getValue() > Ext.getCmp("timeto1").getValue()) {
                                            Ext.Msg.show({
                                                            title : '提示',
                                                            msg : '开始时间不能大于结束时间!',
                                                            minWidth : 200,
                                                            icon : Ext.Msg.ERROR,
                                                            buttons : Ext.Msg.OK
                                                        });
                                            return;
                                        }
                                    }
                                    var validateflag = true;
                                    winOrderRecLocDS.each(function(record){
                                        if((Ext.getCmp("patloc1").getRawValue()==record.get('ARCRLOrdLocDR'))&&(Ext.getCmp("recloc1").getRawValue()==record.get('ARCRLRecLocDesc'))&&(Ext.getCmp("RecLocDateFrom1").getRawValue()==record.get('ARCRLDateFrom'))&&(Ext.getCmp("RecLocDateTo1").getRawValue()==record.get('ARCRLDateTo'))&&(Ext.getCmp("timefrom1").getRawValue()==record.get('ARCRLTimeFrom'))&&(Ext.getCmp("timeto1").getRawValue()==record.get('ARCRLTimeTo'))&&(Ext.getCmp("defaultprior1").getRawValue()==record.get('ARCRLOrderPriorityDesc'))&&(Ext.getCmp("ARCRLCTHospitalDR1").getValue()==record.get('ARCRLCTHospitalDR')))
                                        {
                                            validateflag = false;
                                        }
                                    }, this); //验证新增数据是否存在
                                    if(!validateflag)
                                    {
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"该记录已经存在!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                        })
                                        return;
                                    }
                                     var _record = new Ext.data.Record({
                                        'ARCRLRowId':'',
                                        'ARCRLOrdLocDR':Ext.getCmp("patloc1").getValue(),
                                        'ARCRLOrdLocDesc':Ext.getCmp('patloc1').getRawValue(),
                                        'ARCRLRecLocDR':Ext.getCmp("recloc1").getValue(),
                                        'ARCRLRecLocDesc':Ext.getCmp("recloc1").getRawValue(),
                                        'ARCRLCTHospitalDR':Ext.getCmp("ARCRLCTHospitalDR1").getValue(),
                                        'ARCRLCTHospitalDesc':Ext.getCmp("ARCRLCTHospitalDR1").getRawValue(),
                                        'ARCRLOrderPriorityDR':Ext.getCmp("defaultprior1").getValue(),
                                        'ARCRLOrderPriorityDesc':Ext.getCmp("defaultprior1").getRawValue(),
                                        'ARCRLDefaultFlag':Ext.getCmp("defaultflag1").getValue(),
                                        'ARCRLDateFrom':Ext.getCmp("RecLocDateFrom1").getRawValue(),
                                        'ARCRLDateTo':Ext.getCmp("RecLocDateTo1").getRawValue(),
                                        'ARCRLDefaultFlag':DefaultValue , 
                                        'ARCRLTimeFrom':Ext.getCmp("timefrom1").getRawValue(),
                                        'ARCRLTimeTo':Ext.getCmp("timeto1").getRawValue(),
                                        'ARCRLClinicType':Ext.getCmp("ARCRLClinicType1F").getValue()
                                    });
                                  
                                        winOrderRecLocList.stopEditing();
                                        winOrderRecLocDS.insert(0,_record);        
                                        resetPatLocPanelForAdd()
                                        winOrderRecLocDS.totalLength=Ext.getCmp("winOrderRecLocList").getStore().getTotalCount()+1
                                        Ext.getCmp("winOrderRecLocList").getBottomToolbar().bind(winOrderRecLocDS)
                                    }
                            },{
                                id:'btn_UpOrdRecLoc1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpOrdRecLoc1'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                        if (!winOrderRecLocList.selModel.hasSelection())  
                                        {
                                            Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"请先选择一条医嘱项接收科室!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                            return ;
                                        }
                                        
                                        var DefaultValue=""
                                        if (Ext.getCmp("defaultflag1").getValue()==""){
                                            DefaultValue="N"
                                         }
                                         else if (Ext.getCmp("defaultflag1").getValue()==true){
                                            DefaultValue="Y"
                                         }
                                        if (Ext.getCmp("recloc1").getValue()==""){
                                            Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"接收科室不能为空!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            return ;
                                        }
                                        if (Ext.getCmp("RecLocDateFrom1").getValue()==""){
                                            Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"开始日期不能为空!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            return ;
                                        }
                                        
                                        
                                        if (Ext.getCmp("RecLocDateFrom1").getValue()!="" & Ext.getCmp("RecLocDateTo1").getValue()!="") {
                                            var fromdate=Ext.getCmp("RecLocDateFrom1").getValue().format("Ymd");
                                            var todate=Ext.getCmp("RecLocDateTo1").getValue().format("Ymd");
                                            if (fromdate > todate) {
                                                Ext.Msg.show({
                                                                title : '提示',
                                                                msg : '开始日期不能大于结束日期!',
                                                                minWidth : 200,
                                                                icon : Ext.Msg.ERROR,
                                                                buttons : Ext.Msg.OK
                                                            });
                                                return;
                                            }
                                        }
                                        
                                        if (Ext.getCmp("timefrom1").getValue() != "" && Ext.getCmp("timeto1").getValue() != "") {
                                            if (Ext.getCmp("timefrom1").getValue() > Ext.getCmp("timeto1").getValue()) {
                                                Ext.Msg.show({
                                                                title : '提示',
                                                                msg : '开始时间不能大于结束时间!',
                                                                minWidth : 200,
                                                                icon : Ext.Msg.ERROR,
                                                                buttons : Ext.Msg.OK
                                                            });
                                                return;
                                            }
                                        }
                                        
                                         var myrecord = winOrderRecLocList.getSelectionModel().getSelected();
                                         
                                         var validateflag = true;
                                         winOrderRecLocDS.each(function(record){
                                            if (myrecord!=record) {
                                                if((Ext.getCmp("ARCRLClinicType1").getRawValue()==record.get('ARCRLClinicType'))&&(Ext.getCmp("patloc1").getRawValue()==record.get('ARCRLOrdLocDR'))&&(Ext.getCmp("recloc1").getRawValue()==record.get('ARCRLRecLocDesc'))&&(Ext.getCmp("RecLocDateFrom1").getRawValue()==record.get('ARCRLDateFrom'))&&(Ext.getCmp("RecLocDateTo1").getRawValue()==record.get('ARCRLDateTo'))&&(Ext.getCmp("timefrom1").getRawValue()==record.get('ARCRLTimeFrom'))&&(Ext.getCmp("timeto1").getRawValue()==record.get('ARCRLTimeTo'))&&(Ext.getCmp("defaultprior1").getRawValue()==record.get('ARCRLOrderPriorityDesc'))&&(Ext.getCmp("ARCRLCTHospitalDR1").getValue()==record.get('ARCRLCTHospitalDR'))){
                                                        validateflag = false;
                                                }
                                            }
                                         }, this); //验证新增数据是否存在
                                         if(!validateflag)
                                         {
                                            Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"该记录已经存在!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                            })
                                            return;
                                         }
                                     
                                     
                                         /// 病人科室
                                        myrecord.set('ARCRLOrdLocDesc',Ext.getCmp('patloc1').getRawValue());
                                        /// 接收科室
                                        myrecord.set('ARCRLRecLocDesc',Ext.getCmp('recloc1').getRawValue());
                                        /// 医嘱优先级
                                        myrecord.set('ARCRLOrderPriorityDR',Ext.getCmp('defaultprior1').getValue());
                                        myrecord.set('ARCRLOrderPriorityDesc',Ext.getCmp('defaultprior1').getRawValue());
                                        // 默认
                                        myrecord.set('ARCRLDefaultFlag',Ext.getCmp("defaultflag1").getValue());
                                        myrecord.set('ARCRLDateFrom',Ext.getCmp("RecLocDateFrom1").getRawValue());
                                        myrecord.set('ARCRLDateTo',Ext.getCmp("RecLocDateTo1").getRawValue());
                                        myrecord.set('ARCRLDefaultFlag',DefaultValue);           
                                        myrecord.set('ARCRLTimeFrom',Ext.getCmp("timefrom1").getRawValue());
                                        myrecord.set('ARCRLTimeTo',Ext.getCmp("timeto1").getRawValue());
                                        
                                        ///医院
                                        myrecord.set('ARCRLCTHospitalDR',Ext.getCmp('ARCRLCTHospitalDR1').getValue());
                                        myrecord.set('ARCRLCTHospitalDesc',Ext.getCmp('ARCRLCTHospitalDR1').getRawValue());
                                        
                                        myrecord.set('ARCRLClinicType',Ext.getCmp('ARCRLClinicType1f').getValue());
                                        resetPatLocPanelForAdd();
                                }
                        },{
                                id:'AddwinDeleteOrdRecLoc_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('AddwinDeleteOrdRecLoc_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    winDeleteOrdRecLoc()
                                }
                            },{
                                id:'btn_RefreshOrdRecLoc1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshOrdRecLoc1'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                            resetPatLocPanelForAdd()
                                            
                                    }                 
                            }]
                    
        }; 
    
    var winARCItmRecLocJPanel=new Ext.Panel({
        layout:'border',
        region:'center',
        title:'接收科室',
        items:[winRecLocformDetail,winOrderRecLocList]
    });
    
   
     
     ///////////////////////////////////添加 外部代码 的功能函数///////////////////////////////////
    var AddExtCode=function(){
        
            if (Ext.getCmp("externalcode").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"外部代码不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externalcode").focus();
                 return;
            }
            if (Ext.getCmp("externaldesc").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"描述不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externaldesc").focus();
                 return;
            }                        
            if (Ext.getCmp('reclocdesc').getValue()=='') {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"接收科室不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("reclocdesc").focus();
                 return;
            }
            if (Ext.getCmp("externalDateFrom").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externalDateFrom").focus();
                 return;
            }
            if (Ext.getCmp("externalDateFrom").getValue()!="" & Ext.getCmp("externalDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("externalDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("externalDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能大于结束日期!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
                }
            }        
            var addextcodeset=arcimrowid+"^"+Ext.getCmp("externalcode").getValue()+"^"+Ext.getCmp("externaldesc").getValue()+"^"+Ext.getCmp('reclocdesc').getValue()+"^"+Ext.getCmp("externalDateFrom").getRawValue()+"^"+Ext.getCmp("externalDateTo").getRawValue()+"^"+Ext.getCmp("DefaultReceive").getValue()+"^"+Ext.getCmp("defaultsend").getValue();
            Ext.Ajax.request({
                url:AddOrderExtCode_ACTION_URL,
                method:'POST',
                params:{
                    'SaveDataStr':addextcodeset    
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                                OrderExtCode.load({ 
                                                    params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                });  
                                                resetExtcodePanelForUpdate()
                                                
                                        }
                                });                         
                        }else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                    }
                }else{
                     Ext.Msg.show({
                                title:'提示',
                                msg:"医嘱项外部代码加载失败!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                    }
                }
        })
    };  
    
    ////////////////////////////////////////批量添加 医嘱项外部代码 数据///////////////////////////////////
    var MultiAddExtCode=function(rowid){
             var ARCExtCodeCount=winOrderExtCodeDS.getCount();
             if (ARCExtCodeCount!=0){
                    AddExtCodeStr="";
                    winOrderExtCodeDS.each(function(record){
                    if(AddExtCodeStr!="") AddExtCodeStr = AddExtCodeStr+"*";
                        var datefrom2=record.get('EXTDateFrom');
                        var dateto2=record.get('EXTDateTo')
                        
                        AddExtCodeStr = AddExtCodeStr+record.get('EXTCode')+'^'+record.get('EXTDesc')+'^'+record.get('EXTCTLOCDR')+'^'+record.get('DefaultReceive')+"^"+datefrom2+'^'+dateto2+'^'+record.get('DEfaultSend');
                    }, this);
                }
                else{
                        AddExtCodeStr="";
                }
        Ext.Ajax.request({
            url:MultiAddExtCode_URL,
            method:'POST',
            params:{
                'rowid':rowid,
                'AddExtCodeStr':AddExtCodeStr
            }   
        });  
    }   
    
    /************************************** 修改外部代码 **************************************************/
    var UpdateOrderExtCode=function(){
         
          var records=OrderExtCodeList.selModel.getSelections();
          if(records.length==0){
             Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项外部代码!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
             return; 
         }      
        else{
            if (Ext.getCmp("externalcode").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"外部代码不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externalcode").focus();
                 return;
            }
            if (Ext.getCmp("externaldesc").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"描述不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externaldesc").focus();
                 return;
            }                        
            if (Ext.getCmp('reclocdesc').getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"接收科室不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("reclocdesc").focus();
                 return;
            }
            if (Ext.getCmp("externalDateFrom").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("externalDateFrom").focus();
                 return;
            }
            if (Ext.getCmp("externalDateFrom").getValue()!="" & Ext.getCmp("externalDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("externalDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("externalDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:"开始日期不能大于结束日期!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                });
                 return;
                }
            }
            var ExtcodeRowid=records[0].get('EXTRowId');
            var editextcodeset=ExtcodeRowid+"^"+Ext.getCmp("externalcode").getValue()+"^"+Ext.getCmp("externaldesc").getValue()+"^"+Ext.getCmp('reclocdesc').getValue()+"^"+Ext.getCmp("externalDateFrom").getRawValue()+"^"+Ext.getCmp("externalDateTo").getRawValue()+"^"+Ext.getCmp("DefaultReceive").getValue()+"^"+Ext.getCmp("defaultsend").getValue();       
            Ext.Ajax.request({
                    url:UpdateOrderExtCode_ACTION_URL,
                    method:'POST',
                    params:{
                        'editorderextcode':editextcodeset   //更新医嘱项外部代码
                    },
                    callback:function(options, success, response){
                        if(success){
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                            OrderExtCode.load({ 
                                               params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                               callback: function(r, options, success){
                                                    if(success){
                                                         
                                                    }
                                                    else{
                                                         Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:"医嘱项外部代码加载失败!",
                                                                        icon:Ext.Msg.ERROR,
                                                                        buttons:Ext.Msg.OK
                                                                    });
                                                        }
                                                    }
                                            });  
                                                resetExtcodePanelForUpdate()
                                                
                                        }
                                });                         
                        }else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:jsonData.info,
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                }
                           }else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:"医嘱项外部代码修改失败!",
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                }
                         }
                })
            }
    };
    
    //////////////////////////////////////////////////删除 外部代码数据////////////////////////////////////////////////
    var DeleteOrdExtCode=function(){
         var records=OrderExtCodeList.selModel.getSelections();
          if(records.length==0){
             Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项外部代码!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
             return; 
          }     
          else{
             var gsm = OrderExtCodeList.getSelectionModel(); 
             var rows = gsm.getSelections(); 
             Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
             if(btn=='yes'){
                var records=OrderExtCodeList.selModel.getSelections();
                var ExtcodeRowid=records[0].get('EXTRowId');
                Ext.Ajax.request({
                            url:DeleteOrderExtCode_ACTION_URL,
                            method:'POST',
                            params:{
                                'rowid':ExtcodeRowid   
                            },
                            callback:function(options, success, response){
                                if(success){
                                    OrderExtCode.load({ 
                                        params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                        callback: function(r, options, success){
                                            if(success){
                                                         
                                            }
                                            else{
                                                    Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:"医嘱项外部代码加载失败!",
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                }
                                            }
                                        }); 
                                        resetExtcodePanelForUpdate()
                                        
                                }else{
                                     Ext.Msg.show({
                                                    title:'提示',
                                                    msg:"医嘱项外部代码删除失败!",
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                    }
                             }
                         });
                     }
            }); 
          }
    }
    
    
     ////////////////////////////医嘱项外部代码store
     var OrderExtCode = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ExternalCode_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'EXTRowId', mapping:'EXTRowId',type: 'string'},
           { name: 'EXTCode', mapping:'EXTCode',type: 'string'},
           { name: 'EXTDesc', mapping:'EXTDesc',type: 'string'},
           { name: 'ctlocdesc', mapping:'ctlocdesc',type: 'string'},
           { name: 'DefaultReceive', mapping:'DefaultReceive',type: 'string'},
           { name: 'EXTDateFrom',mapping:'EXTDateFrom',type: 'string'},
           { name: 'EXTDateTo',mapping:'EXTDateTo', type: 'string'},
           { name: 'DEfaultSend', mapping:'DEfaultSend',type: 'string'},
           { name: 'EXTCTLOCDR', mapping:'EXTCTLOCDR',type: 'string'}
        ])
     });
    
    var ExtPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderExtCode,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
    var ExtSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    /** 加载前设置参数 */
    OrderExtCode.on('beforeload',function() {
                    var gsm = OrderExtCodeList.getSelectionModel(); 
                    var rows = gsm.getSelections(); 
                    Ext.apply(OrderExtCode.lastOptions.params, {
                        ParRef:arcimrowid
                    });
            },this);
    // ////////////////////////////创建  医嘱项检验外部外面的grid ////////////////////////////////////////
  var OrderExtCodeList = new Ext.grid.GridPanel({
        id:'OrderExtCodeList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: OrderExtCode,
        trackMouseOver: true,
        columns: [
                ExtSm,
                { header: '外部代码', width: 160, sortable: true, dataIndex: 'EXTCode' },
                { header: '外部描述', width: 160, sortable: true, dataIndex: 'EXTDesc' },
                { header: '接收科室', width: 160, sortable: true, dataIndex: 'ctlocdesc' },
                { header: '默认科室', width: 100, sortable: true, dataIndex: 'DefaultReceive',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: '开始日期', width: 130, sortable: true, dataIndex: 'EXTDateFrom' },
                { header: '结束日期', width: 130, sortable: true, dataIndex: 'EXTDateTo' },
                { header: '单独生成条码', width: 160, sortable: true, dataIndex: 'DEfaultSend',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: 'ARCRLRowId', width: 60, sortable: true, dataIndex: 'EXTRowId', hidden:true},
                { header: '接收科室Dr', width: 60, sortable: true, dataIndex: 'EXTCTLOCDR', hidden:true}
             ],
        stripeRows: true,
        columnLines : true,  
        sm: new Ext.grid.RowSelectionModel({
                        singleSelect: true,
                        listeners: {
                            rowselect: function(sm, row, rec) {                            
                            }
                        }
                    }),
        // config options for stateful behavior
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:ExtPaging ,
        stateId: 'OrderExtCodeList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(OrderExtCodeList,"User.ARCItemExternalCodes");
    
    
    OrderExtCodeList.on("rowclick",function(OrderExtCodeList,rowIndex,e){
        var record = OrderExtCodeList.getSelectionModel().getSelected();
                RowId=record.data['EXTRowId'];
                Ext.getCmp('reclocdesc').setValue(record.data['EXTCTLOCDR']);  //接收科室Dr
                Ext.getCmp("externalcode").setValue(record.data['EXTCode']);
                Ext.getCmp("externaldesc").setValue(record.data['EXTDesc']);
                Ext.getCmp("reclocdesc").setRawValue(record.data['ctlocdesc']);
                Ext.getCmp("externalDateFrom").setValue(record.data['EXTDateFrom']);
                Ext.getCmp("externalDateTo").setValue(record.data['EXTDateTo']);
              
                if (record.data['DefaultReceive']=='Y') {
                     Ext.getCmp("DefaultReceive").setValue("1")
                }
                else {
                     Ext.getCmp("DefaultReceive").setValue("0")
                }             
                if (record.data['DEfaultSend']=='Y') {
                     Ext.getCmp("defaultsend").setValue("1")
                }
                else {
                     Ext.getCmp("defaultsend").setValue("0")
                }             
    }); 
    var ExtCodeformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'医嘱项外部代码',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'85%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>外部代码',
                        xtype:'textfield',  
                        allowBlank : false,
                        id:'externalcode',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalcode'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalcode'))
                    },{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'externalDateFrom',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalDateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalDateFrom')),
                        name: 'EffDate',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'externalDateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalDateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalDateTo')),
                        name: 'EffDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }]
                },{
                    layout: 'form',
                    labelWidth:80,
                    columnWidth: '.27',
                    border:false,
                    defaults: {anchor:'85%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>描述',
                        id:'externaldesc',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externaldesc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externaldesc')),
                        xtype:'textfield',
                        enableKeyEvents:true
                    },{
                        xtype:'checkbox',
                        fieldLabel:'默认科室',
                        id:'DefaultReceive',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DefaultReceive'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DefaultReceive')),
                        inputValue:'Y'
                    }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'85%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>接收科室',
                        id:'reclocdesc',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('reclocdesc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('reclocdesc')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc'
                    },{
                        xtype:'checkbox',
                        fieldLabel:'单独生成条码',
                        id:'defaultsend',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultsend'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultsend')),
                        inputValue:'Y'
                    }]
                }]
            }]}
            
            
            
            ],
            
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddExtCode',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddExtCode'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    var ExtDefaultSendValue="",ExtDefaultReciveValue=""
                                    if(arcimrowid!=""){
                                        AddExtCode()
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_UpdateOrderExtCode',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateOrderExtCode'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                    var ExtDefaultSendValue="",ExtDefaultReciveValue=""
                                    if(arcimrowid!=""){
                                        UpdateOrderExtCode()
                                    }
                                    else{  
                                         Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'DeleteOrdExtCode_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteOrdExtCode_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    if (arcimrowid!=""){
                                        DeleteOrdExtCode()
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                                
                            },{
                                id:'btn_RefreshOrdExtCode',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshOrdExtCode'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        resetExtcodePanelForUpdate()
                                }
                            }]
            
    }; 
    
    //// 创建 医嘱项外部代码的显示面板
    var ARCExtCodeJPanel=new Ext.Panel({
        layout:'border',
        title:'外部代码',
        //frame:true,
        items:[ExtCodeformDetail,OrderExtCodeList]
    });
    
      //////////////////////////////////创建  弹出窗口的  医嘱项检验外部代码 //////////////////////////////////
     ////////////////////////////医嘱项外部代码store*/////////*/////////////
     var winOrderExtCodeDS = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ExternalCode_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'EXTRowId', mapping:'EXTRowId',type: 'string'},
           { name: 'EXTCode', mapping:'EXTCode',type: 'string'},
           { name: 'EXTDesc', mapping:'EXTDesc',type: 'string'},
           { name: 'ctlocdesc', mapping:'ctlocdesc',type: 'string'},
           { name: 'DefaultReceive', mapping:'DefaultReceive',type: 'string'},
           { name: 'EXTDateFrom',mapping:'EXTDateFrom',type: 'string'},
           { name: 'EXTDateTo',mapping:'EXTDateTo', type: 'string'},
           { name: 'DEfaultSend', mapping:'DEfaultSend',type: 'string'},
           { name: 'EXTCTLOCDR', mapping:'EXTCTLOCDR',type: 'string'}
        ])
     });
    
    var winExtPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: winOrderExtCodeDS,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })  
     var winOrderExtCodeList = new Ext.grid.GridPanel({
        id:'winOrderExtCodeList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: winOrderExtCodeDS,
        trackMouseOver: true,
        columns: [
                ExtSm,
                { header: '外部代码', width: 160, sortable: true, dataIndex: 'EXTCode' },
                { header: '外部描述', width: 160, sortable: true, dataIndex: 'EXTDesc' },
                { header: '接收科室', width: 160, sortable: true, dataIndex: 'ctlocdesc' },
                { header: '默认科室', width: 100, sortable: true, dataIndex: 'DefaultReceive',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: '开始日期', width: 130, sortable: true, dataIndex: 'EXTDateFrom' },
                { header: '结束日期', width: 130, sortable: true, dataIndex: 'EXTDateTo' },
                { header: '单独生成条码', width: 160, sortable: true, dataIndex: 'DEfaultSend',renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: 'ARCRLRowId', width: 60, sortable: true, dataIndex: 'EXTRowId', hidden:true},
                { header: '接收科室Dr', width: 60, sortable: true, dataIndex: 'EXTCTLOCDR', hidden:true}
             ],
        stripeRows: true,
        columnLines : true,  
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                rowselect: function(sm, row, rec) {                            
              }
           }
        }),
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:winExtPaging ,
        stateId: 'winOrderExtCodeList'
    });
    winOrderExtCodeList.on("rowclick",function(winOrderExtCodeList,rowIndex,e){
        var record = winOrderExtCodeList.getSelectionModel().getSelected();
        RowId=record.data['EXTRowId'];
        Ext.getCmp('reclocdesc1').setValue(record.data['EXTCTLOCDR']);  //接收科室Dr
        Ext.getCmp("externalcode1").setValue(record.data['EXTCode']);
        Ext.getCmp("externaldesc1").setValue(record.data['EXTDesc']);
        Ext.getCmp("reclocdesc1").setRawValue(record.data['ctlocdesc']);
        Ext.getCmp("externalDateFrom1").setValue(record.data['EXTDateFrom']);
        Ext.getCmp("externalDateTo1").setValue(record.data['EXTDateTo']);
              
        if (record.data['DefaultReceive']=='Y') {
            Ext.getCmp("DefaultReceive1").setValue("1")
        }
        else {
            Ext.getCmp("DefaultReceive1").setValue("0")
        }   
        
        if (record.data['DEfaultSend']=='Y') {
            Ext.getCmp("defaultsend1").setValue("1")
        }
        else {
            Ext.getCmp("defaultsend1").setValue("0")
        }             
    }); 
    
    
    //////////////////////////////////////////////////删除 外部代码数据////////////////////////////////////////////////
    var winDeleteOrdExtCode=function(){
        if(winOrderExtCodeList.selModel.hasSelection()){
           var gsm = winOrderExtCodeList.getSelectionModel(); 
           var rows = gsm.getSelections(); 
           Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
           if(btn=='yes'){
                winOrderExtCodeDS.remove(rows[0]);
                resetExtcodePanelForAdd()
                winOrderExtCodeDS.totalLength=Ext.getCmp("winOrderExtCodeList").getStore().getTotalCount()-1
                Ext.getCmp("winOrderExtCodeList").getBottomToolbar().bind(winOrderExtCodeDS)
            }
        });
      }
        else{
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项外部代码!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }
        }

////////////////////////弹出窗口:医嘱项外部代码维护的面板//////////////////////////////////////////////////////
    var winExtCodeformDetail = {
        id:'winExtCodeform',
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'外部代码维护',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>外部代码',
                        xtype:'textfield',  
                        allowBlank : false,
                        id:'externalcode1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalcode1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalcode1'))
                    },{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'externalDateFrom1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalDateFrom1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalDateFrom1')),
                        name: 'EffDate',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'externalDateTo1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externalDateTo1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externalDateTo1')),
                        name: 'EffDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>描述',
                        id:'externaldesc1',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('externaldesc1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('externaldesc1')),
                        xtype:'textfield',
                        enableKeyEvents:true
                    },{
                        xtype:'checkbox',
                        fieldLabel:'默认科室',
                        id:'DefaultReceive1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DefaultReceive1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DefaultReceive1')),
                        inputValue:'Y'
                    }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>接收科室',
                        id:'reclocdesc1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('reclocdesc1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('reclocdesc1')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'CTLOCRowID',
                        displayField : 'CTLOCDesc'
                    },{
                        xtype:'checkbox',
                        fieldLabel:'单独生成条码',
                        id:'defaultsend1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultsend1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultsend1')),
                        inputValue:'Y'
                    }]
                }]
            }]}
            
            ],
                
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddExtCode1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddExtCode1'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                        var ExtDefaultSendValue="",ExtDefaultReciveValue=""
                                        if (Ext.getCmp("defaultsend1").getValue()==false){
                                            ExtDefaultSendValue="N"
                                        }
                                        else if(Ext.getCmp("defaultsend1").getValue()==true){
                                            ExtDefaultSendValue="Y"
                                        }
                                        if(Ext.getCmp("DefaultReceive1").getValue==false){
                                            ExtDefaultReciveValue="N"
                                        }else if (Ext.getCmp("DefaultReceive1").getValue==true){
                                            ExtDefaultReciveValue="Y"
                                        }
                                        if (Ext.getCmp("externalcode1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"外部代码不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externalcode1").focus();
                                                 return;
                                            }
                                         if (Ext.getCmp("externaldesc1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"描述不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externaldesc1").focus();
                                                 return;
                                            }                        
                                        if (Ext.getCmp('reclocdesc1').getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"接收科室不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("reclocdesc1").focus();
                                                 return;
                                            }
                                         if (Ext.getCmp("externalDateFrom1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externalDateFrom1").focus();
                                                 return;
                                            }
                                            if (Ext.getCmp("externalDateFrom1").getValue()!="" & Ext.getCmp("externalDateTo1").getValue()!="") {
                                                var fromdate=Ext.getCmp("externalDateFrom1").getValue().format("Ymd");
                                                var todate=Ext.getCmp("externalDateTo1").getValue().format("Ymd");
                                                if (fromdate > todate) {
                                                     Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:"开始日期不能大于结束日期!",
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                 return;
                                                }
                                            }
                                            var validateflag = true;
                                            winOrderExtCodeDS.each(function(record){
                                                if((Ext.getCmp("externalcode1").getRawValue()==record.get('EXTCode'))&&(Ext.getCmp("externaldesc1").getRawValue()==record.get('EXTDesc'))&&(Ext.getCmp("reclocdesc1").getRawValue()==record.get('ctlocdesc'))&&(Ext.getCmp("externalDateFrom1").getRawValue()==record.get('EXTDateFrom'))&&(Ext.getCmp("externalDateTo1").getRawValue()==record.get('EXTDateTo'))){
                                                        validateflag = false;
                                                    }
                                                }, this); //验证新增数据是否存在
                                            if(!validateflag)
                                            {
                                                Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"该记录已经存在!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                })
                                                return;
                                            }
                                            
                                            
                                            
                                            
                                         var _record = new Ext.data.Record({
                                            'EXTRowId':'',
                                            'EXTCode':Ext.getCmp("externalcode1").getValue(),
                                            'EXTDesc':Ext.getCmp("externaldesc1").getValue(),
                                            'DefaultReceive':ExtDefaultSendValue,
                                            'DEfaultSend':ExtDefaultSendValue,
                                            'EXTDateFrom':Ext.getCmp("externalDateFrom1").getRawValue(),
                                            'EXTDateTo':Ext.getCmp("externalDateTo1").getRawValue(),
                                            'ctlocdesc':Ext.getCmp('reclocdesc1').getRawValue(),
                                            'EXTCTLOCDR':Ext.getCmp('reclocdesc1').getValue()
                                        });
                                        winOrderExtCodeList.stopEditing();
                                        winOrderExtCodeDS.insert(0,_record);       
                                        resetExtcodePanelForAdd()
                                        winOrderExtCodeDS.totalLength=Ext.getCmp("winOrderExtCodeList").getStore().getTotalCount()+1
                                        Ext.getCmp("winOrderExtCodeList").getBottomToolbar().bind(winOrderExtCodeDS)
                                    }
                                 
                            },{
                                id:'btn_UpdateOrderExtCode1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateOrderExtCode1'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                        var ExtDefaultSendValue="",ExtDefaultReciveValue=""
                                        if (Ext.getCmp("defaultsend1").getValue()==false){
                                            ExtDefaultSendValue="N"
                                        }
                                        else if(Ext.getCmp("defaultsend1").getValue()==true){
                                            ExtDefaultSendValue="Y"
                                        }
                                        if(Ext.getCmp("DefaultReceive1").getValue==false){
                                            ExtDefaultReciveValue="N"
                                        }else if (Ext.getCmp("DefaultReceive1").getValue==true){
                                            ExtDefaultReciveValue="Y"
                                        }
                                        if (Ext.getCmp("externalcode1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"外部代码不能为空,请输入!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externalcode1").focus();
                                                 return;
                                            }
                                         if (Ext.getCmp("externaldesc1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"描述不能为空,请输入!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externaldesc1").focus();
                                                 return;
                                            }                        
                                        if (Ext.getCmp('reclocdesc1').getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"接收科室不能为空,请选择!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("reclocdesc1").focus();
                                                 return;
                                            }
                                         if (Ext.getCmp("externalDateFrom1").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能为空,请选择!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 Ext.getCmp("externalDateFrom1").focus();
                                                 return;
                                         }
                                         if (Ext.getCmp("externalDateFrom1").getValue()!="" & Ext.getCmp("externalDateTo1").getValue()!="") {
                                                var fromdate=Ext.getCmp("externalDateFrom1").getValue().format("Ymd");
                                                var todate=Ext.getCmp("externalDateTo1").getValue().format("Ymd");
                                                if (fromdate > todate) {
                                                     Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:"开始日期不能大于结束日期!",
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                 return;
                                               }
                                        }
                                        
                                        var myrecord = winOrderExtCodeList.getSelectionModel().getSelected();
                                        
                                        var validateflag = true;
                                        winOrderExtCodeDS.each(function(record){
                                            if (myrecord!=record) 
                                            {
                                                if((Ext.getCmp("externalcode1").getRawValue()==record.get('EXTCode'))&&(Ext.getCmp("externaldesc1").getRawValue()==record.get('EXTDesc'))&&(Ext.getCmp("reclocdesc1").getRawValue()==record.get('ctlocdesc'))&&(Ext.getCmp("externalDateFrom1").getRawValue()==record.get('EXTDateFrom'))&&(Ext.getCmp("externalDateTo1").getRawValue()==record.get('EXTDateTo'))){
                                                    validateflag = false;
                                                }
                                            }
                                        }, this); //验证新增数据是否存在
                                        if(!validateflag)
                                        {
                                            Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"该记录已经存在!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                            })
                                            return;
                                        }
                                        
                                        
                                        myrecord.set('EXTCode',Ext.getCmp("externalcode1").getValue());
                                        myrecord.set('EXTDesc',Ext.getCmp("externaldesc1").getValue());
                                        myrecord.set('ctlocdesc',Ext.getCmp('reclocdesc1').getRawValue());
                                        myrecord.set('DefaultReceive',ExtDefaultSendValue);
                                        myrecord.set('DEfaultSend',ExtDefaultSendValue);
                                        myrecord.set('EXTDateFrom',Ext.getCmp("externalDateFrom1").getRawValue());
                                        myrecord.set('EXTDateTo',Ext.getCmp("externalDateTo1").getRawValue());
                                        myrecord.set('EXTCTLOCDR',Ext.getCmp('reclocdesc1').getValue());
                                        
                                        resetExtcodePanelForAdd();
                                       
                                    }
                                 
                            },{
                                id:'winDeleteOrdExtCode_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('winDeleteOrdExtCode_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    winDeleteOrdExtCode()
                                }
                            },{
                                id:'btn_RefreshOrdExtCode1',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshOrdExtCode1'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        resetExtcodePanelForAdd()
                                          
                                        
                                }                 
                            }]
                
    }; 
    
    //// 创建 医嘱项外部代码的显示面板
    var winARCExtCodeJPanel=new Ext.Panel({
        layout:'border',
        title:'外部代码',
        //frame:true,
        items:[winExtCodeformDetail,winOrderExtCodeList]
    });
   
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //获取年龄  
    var GetTrueAge=function(age,type)
    {
        var trueage=""
        if (type=="Y")
        {
            trueage=age*365
        }
        else if (type=="M")
        {
            trueage=age*30
        }
        else if (type=="D")
        {
            trueage=age
        }
        return trueage
    }
    //**********************年龄性别限制 store*************************************************************//
     var OrderAgeSexds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:AGESEX_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },  
          [{ name: 'AGERowId', mapping:'AGERowId',type: 'string'},
           { name: 'AGEAgeFrom', mapping:'AGEAgeFrom',type: 'string'},
           { name: 'AGEAgeTo', mapping:'AGEAgeTo',type: 'string'},
           { name: 'AGESexDR', mapping:'AGESexDR',type: 'string'},
           { name: 'AGEParRef', mapping:'AGEParRef',type: 'string'},
           { name:'AGESexDR2',mapping:'AGESexDR2',type:'string'},
           { name:'AGEAgeFromType',mapping:'AGEAgeFromType',type:'string'},
           { name:'AGEAgeToType',mapping:'AGEAgeToType',type:'string'}
         ])
     });
     var Sexpaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderAgeSexds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })
  /***************************************添加 年龄/性别限制 数据 ********************************/
    var AddOrderAgeSex=function(){
            var ParRef=arcimrowid
            var agefrom=Ext.getCmp("agefrom").getRawValue()
            var ageto=Ext.getCmp("ageto").getRawValue()
            var sexdr=Ext.getCmp("sexdr").getValue()
            var agefromtype=Ext.getCmp("agefromtype").getValue()
            var agetotype=Ext.getCmp("agetotype").getValue()
            if ((Ext.getCmp('sexdr').getValue()=='')){ //&(agefrom=="")&(ageto=="")
                 Ext.Msg.show({
                                title:'提示',
                                msg:"性别不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
            if (((agefrom!="")&&(agefromtype==""))||((ageto!="")&&(agetotype=="")))
            {
                
                Ext.Msg.show({
                        title : '提示',
                        msg : '年龄类型不能为空!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    return;
            }
            if (((agefrom=="")&&(agefromtype!=""))||((ageto=="")&&(agetotype!="")))
            {
                Ext.Msg.show({
                        title : '提示',
                        msg : '年龄不能为空!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    return;
            }

            if (agefrom!=="" && ageto!=="")
            {
                var trueagefrom=GetTrueAge(agefrom,agefromtype)
                var trueageto=GetTrueAge(ageto,agetotype)
                if (trueagefrom > trueageto) {
                    Ext.Msg.show({
                        title : '提示',
                        msg : '开始年龄不能大于截止年龄!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    Ext.getCmp("ageto").focus();
                    return;
                }
            }

            var AddOrderAgeSexStr=ParRef+'^'+sexdr+'^'+agefrom+'^'+ageto+'^'+agefromtype+'^'+agetotype
            
            Ext.Ajax.request({
                url:AddOrderAgeSex_ACTION_URL,
                method:'POST',
                params:{
                    'AddOrderAgeSexStr':AddOrderAgeSexStr
                },
                callback:function(options, success, response){
                if(success){
                    var jsonData = Ext.util.JSON.decode(response.responseText);
                    if(jsonData.success == 'true'){
                        Ext.Msg.show({
                                    title:'提示',
                                    msg:jsonData.info,
                                    icon:Ext.Msg.INFO,
                                    buttons:Ext.Msg.OK,
                                    fn:function(btn){
                                    OrderAgeSexds.load({ 
                                        params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                    }); 
                                        Ext.getCmp("agefrom").reset();
                                        Ext.getCmp("ageto").reset();
                                        Ext.getCmp("sexdr").reset();
                                        Ext.getCmp("agefromtype").reset();
                                        Ext.getCmp("agetotype").reset();
                                    }
                            });                         
                    }else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:jsonData.info,
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            }
                          }else{
                        }
                    }
            })
    };  
    
    /********************************************批量添加 年龄性别限制 数据*********************************/
    var MultiAddAgeSex=function(rowid){
             var ARCAgeSexCount=winOrderAgeSexds.getCount();
             if (ARCAgeSexCount!=0){
                    AddAgeSexStr="";
                    winOrderAgeSexds.each(function(record){
                    if(AddAgeSexStr!="") AddAgeSexStr = AddAgeSexStr+"*";
                        AddAgeSexStr = AddAgeSexStr+record.get('AGESexDR2')+'^'+record.get('AGEAgeFrom')+'^'+record.get('AGEAgeTo')+'^'+record.get('AGEAgeFromType')+'^'+record.get('AGEAgeToType');
                    }, this);
                }
                else{
                    AddAgeSexStr="";
                }
        Ext.Ajax.request({
            url:MultiAddOrderAgeSex_URL,
            method:'POST',
            params:{
                'rowid':rowid,
                'AddAgeSexStr':AddAgeSexStr
            }   
        });  
    }
    /***********************************修改 年龄性别限制 数据********************************************/
    var UpdateOrderAgeSex=function(){
          var editextcodeset="";
          var records = AgeSexdsList.selModel.getSelections();
            if (records.length>0){
            var rowid=records[0].get('AGERowId');
            if (rowid=="") { 
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项年龄/性别限制!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }       
            var rowid="" ,agefrom="" ,ageto="" ,sexdr="" ,agefromtype="",agetotype=""
            var records = AgeSexdsList.selModel.getSelections();
            var rowid=records[0].get('AGERowId');
            
            agefrom=Ext.getCmp("agefrom").getRawValue()
            ageto=Ext.getCmp("ageto").getRawValue()
            sexdr=Ext.getCmp("sexdr").getValue()
            agefromtype=Ext.getCmp("agefromtype").getValue()
            agetotype=Ext.getCmp("agetotype").getValue()

            if ((Ext.getCmp('sexdr').getValue()=="")){  //&(agefrom=="")&(ageto=="")
                  Ext.Msg.show({
                                title:'提示',
                                msg:"性别不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("sexdr").focus();
                 return;
            }

            if ((Ext.getCmp('sexdr').getValue()=='')){ //&(agefrom=="")&(ageto=="")
                 Ext.Msg.show({
                                title:'提示',
                                msg:"性别不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
            if (((agefrom!="")&&(agefromtype==""))||((ageto!="")&&(agetotype=="")))
            {
                
                Ext.Msg.show({
                        title : '提示',
                        msg : '年龄类型不能为空!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    return;
            }
            if (((agefrom=="")&&(agefromtype!=""))||((ageto=="")&&(agetotype!="")))
            {
                Ext.Msg.show({
                        title : '提示',
                        msg : '年龄不能为空!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    return;
            }
            
            if (agefrom!=="" && ageto!=="")
            {
                var trueagefrom=GetTrueAge(agefrom,agefromtype)
                var trueageto=GetTrueAge(ageto,agetotype)
                if (trueagefrom > trueageto) {
                    Ext.Msg.show({
                        title : '提示',
                        msg : '开始年龄不能大于截止年龄!',
                        minWidth : 200,
                        icon : Ext.Msg.ERROR,
                        buttons : Ext.Msg.OK
                    });
                    Ext.getCmp("ageto").focus();
                    return;
                }
            }
            
            
            var UpdateOrderAgeSexStr=rowid+'^'+sexdr+'^'+agefrom+'^'+ageto+'^'+agefromtype+'^'+agetotype
            Ext.Ajax.request({
                url:UpdateOrderAgeSex_ACTION_URL,
                method:'POST',
                params:{
                        'UpdateOrderAgeSexStr':UpdateOrderAgeSexStr
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                                OrderAgeSexds.load({ 
                                                        params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} });  
                                                        Ext.getCmp("agefrom").reset();
                                                        Ext.getCmp("ageto").reset();
                                                        Ext.getCmp("sexdr").reset();
                                                        Ext.getCmp("agefromtype").reset();
                                                        Ext.getCmp("agetotype").reset();
                                                    }
                                                });                         
                                            }else{
                                                Ext.Msg.show({
                                                                title:'提示',
                                                                msg:jsonData.info,
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                        }
                                          }else{
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"医嘱项年龄/性别限制修改失败!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                             });
                                                        }
                                                    }
                                            })
                                        }
    };
                    
                    
        
    var AgeSexSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    /////////////////////创建 医嘱项 年龄性别 列表 ,用于 tabpanel////////////////////////////
    
  var AgeSexdsList = new Ext.grid.GridPanel({
        id:'AgeSexdsList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: OrderAgeSexds,
        trackMouseOver: true,
        columns: [
                AgeSexSm,{ header: '性别', width: 120, sortable: true, dataIndex: 'AGESexDR' },
                { header: '开始年龄', width: 60, sortable: true, dataIndex: 'AGEAgeFrom' },
                { header: '开始年龄类型', width: 120, sortable: true, dataIndex: 'AGEAgeFromType' },
                { header: '截止年龄', width: 60, sortable: true, dataIndex: 'AGEAgeTo' },
                { header: '截止年龄类型', width: 120, sortable: true, dataIndex: 'AGEAgeToType' },
                { header: 'AGERowId', width: 60, sortable: true, dataIndex: 'AGERowId', hidden:true},
                { header: 'AGEParRef', width: 60, sortable: true, dataIndex: 'AGEParRef', hidden:true},
                { header:'AGESexDR2',width: 60, sortable: true, dataIndex: 'AGESexDR2', hidden:true}
             ],
        stripeRows: true,
        columnLines : true, 
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                   rowselect: function(sm, row, rec) {                            
                 }
               }
        }),
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:Sexpaging ,
        stateId: 'AgeSexdsList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(AgeSexdsList,"User.ARCItemAgeSexRestriction");
    
    
  AgeSexdsList.on("rowclick",function(AgeSexdsList,rowIndex,e){
        var record = AgeSexdsList.getSelectionModel().getSelected();
        RowId=record.data['AGERowId'];
        Ext.getCmp('agefrom').setValue(record.data['AGEAgeFrom']);   
        Ext.getCmp("ageto").setValue(record.data['AGEAgeTo']);
        Ext.getCmp('sexdr').setValue(record.data['AGESexDR2']);   
        Ext.getCmp("sexdr").setRawValue(record.data['AGESexDR']);
        Ext.getCmp('agefromtype').setValue(GetAgeType(record.data['AGEAgeFromType']));   
        Ext.getCmp("agetotype").setValue(GetAgeType(record.data['AGEAgeToType']));
    }); 
    var GetAgeType=function(agetype){
        if (agetype=="岁")
        {
            agetype="Y"
        }
        else if (agetype=="月")
        {
            agetype="M"
        }
        else if (agetype=="日")
        {
            agetype="D"
        }
        return agetype
    }
 //////////////////////////// 年龄性别限制的 form面板//////////////////////////////////
    
var AgeSexPanel=new Ext.form.FormPanel({
            region:'north',
            height:125,
            labelAlign : 'right',
            frame:true,
            items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                anchor:'96%',
                title:'年龄/性别限制',
                items : [{
                         fieldLabel: 'RowId',
                         hideLabel:'True',
                         hidden : true,
                         name: 'RowId'
                    },{
                        
                         columnWidth : .33,  
                         layout : "form", 
                         items : [{  
                                    fieldLabel: '<font color=red>*</font>性别',
                                    allowBlank:false,
                                    xtype:'bdpcombo',
                                    width:130,
                                    name : 'AGESexDR',
                                    id:'sexdr',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('sexdr'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('sexdr')) ,
                                    store : new Ext.data.Store({
                                            proxy : new Ext.data.HttpProxy({ url : CTSEXQUERY_ACTION_URL }),
                                            reader : new Ext.data.JsonReader({
                                            totalProperty : 'total',
                                            root : 'data',
                                            successProperty : 'success'
                                        }, [ 'CTSEXRowId', 'CTSEXDesc'])
                                    }),
                                    queryParam : 'desc',
                                    forceSelection : true,
                                    selectOnFocus : false, 
                                    minChars : 0,
                                    listWidth:250,
                                    pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                                    valueField : 'CTSEXRowId',
                                    displayField : 'CTSEXDesc'
                                 },{
                                    fieldLabel: '截止年龄',
                                    xtype:'numberfield',
                                    width:130,
                                    minValue : 0,
                                    allowNegative : false,//不允许输入负数
                                    id:'ageto',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('ageto'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ageto'))
                            }]
                     }, {
                        columnWidth : .33,
                        layout : "form",
                        items : [   //AgeFrom
                                {
                                    fieldLabel: '开始年龄',
                                    xtype:'numberfield',    
                                    width:130,
                                    minValue : 0,
                                    allowNegative : false,//不允许输入负数
                                    id:'agefrom',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('agefrom'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('agefrom'))
                            },{
                                xtype : 'combo',
                                fieldLabel : '截止年龄类型',
                                id:'agetotype',
                                
                                mode : 'local',
                                store : new Ext.data.SimpleStore({
                                            fields : ['value', 'text'],
                                            data : [
                                                        ['Y', '岁'],
                                                        ['M', '月'],
                                                        ['D', '日']
                                                    ]
                                        }),
                                emptyText:'年龄类型',
                                triggerAction : 'all',
                                forceSelection : true,
                                selectOnFocus : false,
                                //typeAhead : true,
                                //minChars : 1,
                                valueField : 'value',
                                displayField : 'text',
                                width:130
                            }]
                    },{
                         columnWidth : .33,
                         layout : "form",
                         items : [  //AgeTo
                                    {
                                            xtype : 'combo',
                                            fieldLabel : '开始年龄类型',
                                            id:'agefromtype',
                                           mode : 'local',
                                            store : new Ext.data.SimpleStore({
                                                        fields : ['value', 'text'],
                                                        data : [
                                                                    ['Y', '岁'],
                                                                    ['M', '月'],
                                                                    ['D', '日']
                                                                ]
                                                    }),
                                            emptyText:'年龄类型',
                                            triggerAction : 'all',
                                            forceSelection : true,
                                            selectOnFocus : false,
                                            //typeAhead : true,
                                            //minChars : 1,
                                            valueField : 'value',
                                            displayField : 'text',
                                            width:130
                                        }]
                            }]
                    }]
                }],
            buttonAlign:'center', 
            buttons:[{  
                    id:'btn_AddAgeSex',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddAgeSex'),
                    text:'添加',
                    iconCls : 'icon-add',
                    width: 60,
                    handler: function (){
                    
                        if (arcimrowid!="") {
                            AddOrderAgeSex();
                        }else{
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                        });
                         return;
                    }
              }
         },
                {  
                    id:'btn_UpdateAgeSex',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateAgeSex'),
                    text:'修改',
                    iconCls : 'icon-update',
                    width: 60,
                    handler: function (){ 
                        if (arcimrowid!="") {
                            UpdateOrderAgeSex();
                        }else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                             return;
                         }
                       }
                }, {  
                    id:'DeleteAgeSex_del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteAgeSex_del_btn'),
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    handler: function (){ 
                        if (arcimrowid==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                          return;
                        }
                        if(AgeSexdsList.selModel.hasSelection()){
                            var gsm = AgeSexdsList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                var DelAgeRowid=rows[0].get('AGERowId');
                                if(DelAgeRowid==""){  
                             
                                }
                                else{
                                        var records = AgeSexdsList.selModel.getSelections();
                                        var DelAgeRowid=records[0].get('AGERowId');
                                        Ext.Ajax.request({
                                                url:DeleteOrderAgeSex_ACTION_URL,
                                                method:'POST',
                                                params:{
                                                   'rowid':DelAgeRowid
                                                },
                                                callback:function(options, success, response){
                                                Ext.MessageBox.hide();
                                                if(success){
                                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                                    if(jsonData.success == 'true'){
                                                        Ext.getCmp("sexdr").reset();
                                                        Ext.getCmp("agefrom").reset();                                                                  
                                                        Ext.getCmp("ageto").reset();
                                                        Ext.getCmp("agefromtype").reset();                                                                  
                                                        Ext.getCmp("agetotype").reset();
                                                        OrderAgeSexds.load({ 
                                                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                    });   
                                                }
                                            else{
                                                    var errorMsg ='';
                                                    if(jsonData.info){
                                                    errorMsg='<br />错误信息:'+jsonData.info
                                                }
                                                Ext.Msg.show({
                                                                title:'提示',
                                                                msg:'数据删除失败!'+errorMsg,
                                                                minWidth:200,
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                }
                                        }
                                        else{
                                            Ext.Msg.show({
                                                            title:'提示',
                                                            msg:'异步通讯失败,请检查网络连接!',
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                                }
                                        }
                                    },this);
                                  }
                            }
                        },this);
                    }
                    else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项年龄/性别限制!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                            }
                    }
                },{             
                    id:'btn_RefreshAgeSex',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshAgeSex'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function()
                    {
                        Ext.getCmp("sexdr").reset();
                        Ext.getCmp("agefrom").reset();                                                                  
                        Ext.getCmp("ageto").reset();
                        Ext.getCmp("agefromtype").reset();                                                                  
                        Ext.getCmp("agetotype").reset();
                        var linenum=AgeSexdsList.getSelectionModel().lastActive;   
                        AgeSexdsList.getSelectionModel().deselectRow(linenum)
                        OrderAgeSexds.load({ 
                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                        });  
                    }
                }]
    }); 
    
    var AgeSexJPanel=new Ext.Panel({
        id:'AgeSexPanel',
        title:'年龄/性别限制',
        layout:'border',
        items:[AgeSexPanel,AgeSexdsList]
    });
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //**********************年龄性别限制 store*************************************************************//
     var winOrderAgeSexds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:AGESEX_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },  
          [{ name: 'AGERowId', mapping:'AGERowId',type: 'string'},
           { name: 'AGEAgeFrom', mapping:'AGEAgeFrom',type: 'string'},
           { name: 'AGEAgeTo', mapping:'AGEAgeTo',type: 'string'},
           { name: 'AGESexDR', mapping:'AGESexDR',type: 'string'},
           { name: 'AGEParRef', mapping:'AGEParRef',type: 'string'},
           { name:'AGESexDR2',mapping:'AGESexDR2',type:'string'},
           { name:'AGEAgeFromType',mapping:'AGEAgeFromType',type:'string'},
           { name:'AGEAgeToType',mapping:'AGEAgeToType',type:'string'}
         ])
     });
     var winSexpaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: winOrderAgeSexds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })
    ///////// 弹窗tab 中的  年龄性别限制 /////////////////////////////
     var winAgeSexdsList = new Ext.grid.GridPanel({
        id:'winAgeSexdsList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: winOrderAgeSexds,
        trackMouseOver: true,
        columns: [
                AgeSexSm,{ header: '性别', width: 120, sortable: true, dataIndex: 'AGESexDR' },
                { header: '开始年龄', width: 60, sortable: true, dataIndex: 'AGEAgeFrom' },
                { header: '开始年龄类型', width: 120, sortable: true, dataIndex: 'AGEAgeFromType' },
                { header: '截止年龄', width: 60, sortable: true, dataIndex: 'AGEAgeTo' },
                { header: '截止年龄类型', width: 120, sortable: true, dataIndex: 'AGEAgeToType' },
                { header: 'AGERowId', width: 60, sortable: true, dataIndex: 'AGERowId', hidden:true},
                { header: 'AGEParRef', width: 60, sortable: true, dataIndex: 'AGEParRef', hidden:true},
                { header:'AGESexDR2',width: 60, sortable: true, dataIndex: 'AGESexDR2', hidden:true}
             ],
        stripeRows: true,
        columnLines : true, 
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                    rowselect: function(sm, row, rec) {                            
                }
             }
        }),
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:winSexpaging ,
        stateId: 'AgeSexdsList'
    });
  winAgeSexdsList.on("rowclick",function(winAgeSexdsList,rowIndex,e){
        var record = winAgeSexdsList.getSelectionModel().getSelected();
        RowId=record.data['AGERowId'];
        Ext.getCmp('agefrom1').setValue(record.data['AGEAgeFrom']);   
        Ext.getCmp("ageto1").setValue(record.data['AGEAgeTo']);
        Ext.getCmp('sexdr1').setValue(record.data['AGESexDR2']);   
        Ext.getCmp("sexdr1").setRawValue(record.data['AGESexDR']);
        Ext.getCmp('agefromtype1').setValue(record.data['AGEAgeFromType']);   
        Ext.getCmp("agetotype1").setValue(record.data['AGEAgeToType']);
    }); 
 ////////// 年龄性别限制的 form面板/////////////////////////////////////////////////////////////////
    
var winAgeSexPanel=new Ext.form.FormPanel({
            id:'winAgeSexPanel',
            region:'north',
            height:125,
            labelAlign : 'right',
            frame:true,
            items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                anchor:'96%',
                title:'年龄/性别限制',
                items : [{
                         fieldLabel: 'RowId',
                         hideLabel:'True',
                         hidden : true,
                         name: 'RowId'
                    },{
                         columnWidth : .33,  
                         layout : "form", 
                         items : [{  
                                    fieldLabel: '<font color=red>*</font>性别',
                                    allowBlank:false,
                                    xtype:'bdpcombo',
                                    width:130,
                                    name : 'AGESexDR',
                                    id:'sexdr1',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('sexdr1'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('sexdr1')) ,
                                    store : new Ext.data.Store({
                                            proxy : new Ext.data.HttpProxy({ url : CTSEXQUERY_ACTION_URL }),
                                            reader : new Ext.data.JsonReader({
                                            totalProperty : 'total',
                                            root : 'data',
                                            successProperty : 'success'
                                        }, [ 'CTSEXRowId', 'CTSEXDesc'])
                                    }),
                                    queryParam : 'desc',
                                    forceSelection : true,
                                    selectOnFocus : false, 
                                    minChars : 0,
                                    listWidth:250,
                                    pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                                    valueField : 'CTSEXRowId',
                                    displayField : 'CTSEXDesc'
                                 },{
                                    fieldLabel: '截止年龄',
                                    xtype:'numberfield',
                                    minValue : 0,
                                    allowNegative : false,//不允许输入负数
                                    width:130,
                                    id:'ageto1',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('ageto1'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ageto1'))
                                  }]
                     }, {
                        columnWidth : .33,
                        layout : "form",
                        items : [   //AgeFrom1
                                {
                                    fieldLabel: '开始年龄',
                                    xtype:'numberfield',    
                                    width:130,
                                    minValue : 0,
                                    allowNegative : false,//不允许输入负数
                                    id:'agefrom1',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('agefrom1'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('agefrom1'))
                            },{
                                xtype : 'combo',
                                fieldLabel : '截止年龄类型',
                                id:'agetotype1',
                                mode : 'local',
                                store : new Ext.data.SimpleStore({
                                            fields : ['value', 'text'],
                                            data : [
                                                        ['Y', '岁'],
                                                        ['M', '月'],
                                                        ['D', '日']
                                                    ]
                                        }),
                                emptyText:'年龄类型',
                                typeAhead: true,
                                triggerAction : 'all',                                
                                valueField : 'value',
                                displayField : 'text',
                                width:130
                            }]
                    },{
                         columnWidth : .33,
                         layout : "form",
                         items : [  //AgeTo1
                                    {
                                    xtype : 'combo',
                                    fieldLabel : '开始年龄类型',
                                    id:'agefromtype1',
                                     mode : 'local',
                                    store : new Ext.data.SimpleStore({
                                                fields : ['value', 'text'],
                                                data : [
                                                            ['Y', '岁'],
                                                            ['M', '月'],
                                                            ['D', '日']
                                                        ]
                                            }),
                                    emptyText:'年龄类型',
                                    triggerAction : 'all',
                                    forceSelection : true,
                                    selectOnFocus : false,
                                    //typeAhead : true,
                                    //minChars : 1,
                                    valueField : 'value',
                                    displayField : 'text',
                                    width:130
                                }]
                            }]
                    }]
                }],
            buttonAlign:'center', 
            buttons:[{  
                    id:'btn_AddAgeSex1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddAgeSex1'),
                    text:'添加',
                    iconCls : 'icon-add',
                    width: 60,
                    handler: function (){
                    
                        if((Ext.getCmp("sexdr1").getValue()==""))  //&&(Ext.getCmp('agefrom1').getValue()=="")&&(Ext.getCmp('ageto1').getValue()=="")
                        {
                             Ext.Msg.show({
                                            title:'提示',
                                            msg:"性别不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                            return ;
                        }
                        var agefrom1=Ext.getCmp("agefrom1").getRawValue()
                        var ageto1=Ext.getCmp("ageto1").getRawValue()
                        var agefromtype1=Ext.getCmp("agefromtype1").getValue()
                        var agetotype1=Ext.getCmp("agetotype1").getValue()

                        if (((agefrom1!="")&&(agefromtype1==""))||((ageto1!="")&&(agetotype1=="")))
                        {
                            
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : '年龄类型不能为空!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                return;
                        }
                        if (((agefrom1=="")&&(agefromtype1!=""))||((ageto1=="")&&(agetotype1!="")))
                        {
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : '年龄不能为空!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                return;
                        }
                        
                        if (agefrom1!=="" && ageto1!=="")
                        {
                            var trueagefrom1=GetTrueAge(agefrom1,agefromtype1)
                            var trueageto1=GetTrueAge(ageto1,agetotype1)
                            if (trueagefrom1 > trueageto1) {
                                Ext.Msg.show({
                                    title : '提示',
                                    msg : '开始年龄不能大于截止年龄!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                Ext.getCmp("ageto1").focus();
                                return;
                            }
                        }    

                        var _record = new Ext.data.Record({
                            'AGERowId':'',
                            'AGESexDR':Ext.getCmp("sexdr1").getRawValue(),
                            'AGESexDR2':Ext.getCmp("sexdr1").getValue(),
                            'AGEAgeFrom':Ext.getCmp('agefrom1').getValue(),
                            'AGEAgeTo':Ext.getCmp('ageto1').getValue(),
                            'AGEAgeFromType':Ext.getCmp('agefromtype1').getValue(),
                            'AGEAgeToType':Ext.getCmp('agetotype1').getValue()
                        });
                        
                        var validateflag = true;
                        winOrderAgeSexds.each(function(record){
                            if((Ext.getCmp("agefrom1").getValue()==record.get('AGEAgeFrom'))&&(Ext.getCmp("ageto1").getRawValue()==record.get('AGEAgeTo'))&&(Ext.getCmp("sexdr1").getRawValue()==record.get('AGESexDR'))&&(Ext.getCmp("agefromtype1").getValue()==record.get('AGEAgeFromType'))&&(Ext.getCmp("agetotype1").getRawValue()==record.get('AGEAgeToType'))){
                                validateflag = false;
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                        
                        winAgeSexdsList.stopEditing();
                        winOrderAgeSexds.insert(0,_record); 
                        winOrderAgeSexds.totalLength=Ext.getCmp("winAgeSexdsList").getStore().getTotalCount()+1
                        Ext.getCmp("winAgeSexdsList").getBottomToolbar().bind(winOrderAgeSexds)
                        Ext.getCmp("sexdr1").reset();
                        Ext.getCmp("agefrom1").reset();                                                                 
                        Ext.getCmp("ageto1").reset(); 
                        Ext.getCmp("agefromtype1").reset();                                                                 
                        Ext.getCmp("agetotype1").reset(); 
                    
             }
         }, {  
                    id:'btn_UpdateAgeSex1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateAgeSex1'),
                    text:'修改',
                    iconCls : 'icon-update',
                    width: 60,
                    handler: function (){ 
                        
                        
                    if(winAgeSexdsList.selModel.hasSelection()){
                         if((Ext.getCmp("sexdr1").getValue()==""))  //&&(Ext.getCmp('agefrom1').getValue()=="")&&(Ext.getCmp('ageto1').getValue()=="")
                         {
                             Ext.Msg.show({
                                            title:'提示',
                                            msg:"性别不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                            return ;
                         }
                        
                        var agefrom1=Ext.getCmp("agefrom1").getRawValue()
                        var ageto1=Ext.getCmp("ageto1").getRawValue()
                        var agefromtype1=Ext.getCmp("agefromtype1").getValue()
                        var agetotype1=Ext.getCmp("agetotype1").getValue()

                        if (((agefrom1!="")&&(agefromtype1==""))||((ageto1!="")&&(agetotype1=="")))
                        {
                            
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : '年龄类型不能为空!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                return;
                        }
                        if (((agefrom1=="")&&(agefromtype1!=""))||((ageto1=="")&&(agetotype1!="")))
                        {
                            Ext.Msg.show({
                                    title : '提示',
                                    msg : '年龄不能为空!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                return;
                        }
                        
                        if (agefrom1!=="" && ageto1!=="")
                        {
                            var trueagefrom1=GetTrueAge(agefrom1,agefromtype1)
                            var trueageto1=GetTrueAge(ageto1,agetotype1)
                            if (trueagefrom1 > trueageto1) {
                                Ext.Msg.show({
                                    title : '提示',
                                    msg : '开始年龄不能大于截止年龄!',
                                    minWidth : 200,
                                    icon : Ext.Msg.ERROR,
                                    buttons : Ext.Msg.OK
                                });
                                Ext.getCmp("ageto1").focus();
                                return;
                            }
                        }  

                        /*if ((Ext.getCmp('agefrom1').getValue()!="")&&(Ext.getCmp('ageto1').getValue()!="")&&((Ext.getCmp('agefrom1').getValue()!="")>(Ext.getCmp('ageto1').getValue()))){
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"开始年龄不能大于截止年龄!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                                return ;
                            }*/
                        var myrecord = winAgeSexdsList.getSelectionModel().getSelected();
                        var validateflag = true;
                        winOrderAgeSexds.each(function(record){
                            if (myrecord!=record) 
                            {
                                if((Ext.getCmp("agefrom1").getValue()==record.get('AGEAgeFrom'))&&(Ext.getCmp("ageto1").getRawValue()==record.get('AGEAgeTo'))&&(Ext.getCmp("sexdr1").getRawValue()==record.get('AGESexDR'))&&(Ext.getCmp("agefromtype1").getValue()==record.get('AGEAgeFromType'))&&(Ext.getCmp("agetotype1").getRawValue()==record.get('AGEAgeToType'))){
                                    validateflag = false;
                                }
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                          myrecord.set('AGESexDR',Ext.getCmp('sexdr1').getRawValue());
                          myrecord.set('AGEAgeFrom',Ext.getCmp('agefrom1').getValue());
                          myrecord.set('AGEAgeTo',Ext.getCmp('ageto1').getValue());
                          myrecord.set('AGESexDR2',Ext.getCmp("sexdr1").getValue());
                          myrecord.set('AGEAgeFromType',Ext.getCmp('agefromtype1').getValue());
                          myrecord.set('AGEAgeToType',Ext.getCmp('agetotype1').getValue());

                          Ext.getCmp("sexdr1").reset();
                          Ext.getCmp("agefrom1").reset();                                                                   
                          Ext.getCmp("ageto1").reset(); 
                          Ext.getCmp("agefromtype1").reset();                                                                   
                          Ext.getCmp("agetotype1").reset(); 
                            
                    }
                    else{
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项年龄/性别限制!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                     });
                        }
                  }
                }, {  
                    id:'DeleteAgeSex1_del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteAgeSex1_del_btn'),
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    handler: function (){ 
                        if(winAgeSexdsList.selModel.hasSelection()){
                            var gsm = winAgeSexdsList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                    winOrderAgeSexds.remove(rows[0]);
                                    winOrderAgeSexds.totalLength=Ext.getCmp("winAgeSexdsList").getStore().getTotalCount()-1
                                    Ext.getCmp("winAgeSexdsList").getBottomToolbar().bind(winOrderAgeSexds)
                                    Ext.getCmp("sexdr1").setValue('');
                                    Ext.getCmp("agefrom1").setValue('');                                                                    
                                    Ext.getCmp("ageto1").setValue('');
                                    Ext.getCmp("agefromtype1").setValue('');                                                                    
                                    Ext.getCmp("agetotype1").setValue('');
                                    var linenum=winAgeSexdsList.getSelectionModel().lastActive;   
                                    winAgeSexdsList.getSelectionModel().deselectRow(linenum);
                            }
                        })
                   }
                    else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项年龄/性别限制!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                        }
                  }
                },{             
                    id:'btn_RefreshAgeSex1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshAgeSex1'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function()
                    {
                        Ext.getCmp("sexdr1").reset();
                        Ext.getCmp("agefrom1").reset();                                                                 
                        Ext.getCmp("ageto1").reset();
                        Ext.getCmp("agefromtype1").setValue('');                                                                    
                        Ext.getCmp("agetotype1").setValue('');
                        var linenum=winAgeSexdsList.getSelectionModel().lastActive;  //取消选择行
                        winAgeSexdsList.getSelectionModel().deselectRow(linenum)
                        winOrderAgeSexds.load({ 
                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                        });  
                    }
                }]
    }); 
    //// 弹窗中的 tabpanel  年龄性别限制
    var winAgeSexJPanel=new Ext.Panel({
        id:'winAgeSexJPanel',
        title:'年龄/性别限制',
        layout:'border',
        items:[winAgeSexPanel,winAgeSexdsList]
    });
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
     /********************************医院关联的存储store********************************************************/
    
    var OrderHospStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:Hosp_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },[ {name: 'HOSPRowId', mapping:'HOSPRowId',type: 'string'},
                {name:'HospDr',mapping:'HospDr',type:'string'},
                { name: 'HOSPHospitalDR', mapping:'HOSPHospitalDR',type: 'string'}      
            ])
     });
     /******************************* 医院关联的分页工具条************************************************/
        var Hosppaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderHospStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        });     
      
    /****************************创建 医院关联的表格************************************************/ 
      var OrderHospSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
      var OrderHospList = new Ext.grid.GridPanel({
            id:'OrderHospList',
            region: 'center',
            width:800,
            height:700,
            closable:true,
            store: OrderHospStore,
            trackMouseOver: true,
            columns: [
                OrderHospSm,
                { header: 'HOSPRowId', width: 80, sortable: true, dataIndex: 'HOSPRowId', hidden:true},
                { header:'HospDr',width:80,sortable:true,dataIndex:'HospDr',hidden:true},
                { header: '医院', width: 160, sortable: true, dataIndex: 'HOSPHospitalDR' }
             ],
            stripeRows: true,
            columnLines : true, 
            stateful: true,
            viewConfig: { forceFit: true },
            bbar:Hosppaging,
            stateId: 'OrderHospList'
        });
    //Ext.BDP.FunLib.ShowUserHabit(OrderHospList,"User.ARCItemHosp");   
    
    /// 点击表格时,加载选中行的医院关联的数据。
        OrderHospList.on("rowclick",function(OrderHospList,rowIndex,e){
            var record = OrderHospList.getSelectionModel().getSelected();
            RowId=record.data['llergyRowId'];
            Ext.getCmp("txtHospital").setRawValue(record.data['HOSPHospitalDR']);
        });  
   
    /******************************添加医嘱项关联的医院***********************************************/
    var AddOrderHosp=function(){
            var HospStr="";
            HospStr=arcimrowid+"^"+Ext.getCmp("txtHospital").getValue();
            Ext.Ajax.request({
                url:AddHosp_ACTION_URL,
                    method:'POST',
                    params:{
                        'SaveDataStr':HospStr       
                    },
                    callback:function(options, success, response){
                        if(success){
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                                Ext.Msg.show({
                                        title:'提示',
                                        msg:jsonData.info,
                                        icon:Ext.Msg.INFO,
                                        buttons:Ext.Msg.OK,
                                        fn:function(btn){                                       
                                            OrderHospStore.load({
                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                                callback: function(r, options, success){
                                                    if(success){
                                                    }
                                                    else{
                                                        Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:"医嘱项关联医院加载失败!",
                                                                        icon:Ext.Msg.ERROR,
                                                                        buttons:Ext.Msg.OK
                                                                    });
                                                        }
                                                    }
                                            });  
                                            Ext.getCmp("txtHospital").reset();
                                            HospStr="";
                                        }
                                    });                         
                                }else{
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:jsonData.info,
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                        }
                            }else{ 
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:"医嘱项关联医院添加失败!",
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                }
                         }
                    })
            };
            
    /////////////////////////////批量 添加 医院关联 ////////////////////////////////////////            
    var MultiAddHosp=function(rowid){
        var HospitalAddStr="";
        var ARCHospCount=winOrderHospStore.getCount();
        if (ARCHospCount!=0){
                
                winOrderHospStore.each(function(record){
                    if(HospitalAddStr!="") HospitalAddStr = HospitalAddStr+"*";
                    HospitalAddStr = HospitalAddStr+record.get('HospDr');
                  }, this);
                }
                else{
                    HospitalAddStr="";
                }
         
        Ext.Ajax.request({
            url:MultiAddHosp_URL,
            method:'POST',
            params:{
                'rowid':rowid,
                'HospitalAddStr':HospitalAddStr
            }   
        });  
    }
    
    
/********************************修改医嘱项医院关联****************************************************/
    var EditOrderHosp=function(){
            var HospStr="";
            var records = OrderHospList.selModel.getSelections();
            if (records.length>0){
            
             if(Ext.getCmp("txtHospital").getValue()==""){
                Ext.Msg.show({
                                title:'提示',
                                msg:'请先选择一条医嘱项医院!',
                                minWidth:200,
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                    return 
                }
          
            var rowid=records[0].get('HOSPRowId');
            HospStr=rowid+"^"+Ext.getCmp("txtHospital").getValue();
            Ext.Ajax.request({
                                url:UpdateHosp_ACTION_URL,
                                method:'POST',
                                params:{'HospStr':HospStr },  //更新医院关联的医院
                                callback:function(options, success, response){
                                    if(success){
                                        var jsonData = Ext.util.JSON.decode(response.responseText);
                                        if(jsonData.success == 'true'){
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:jsonData.info,
                                                        icon:Ext.Msg.INFO,
                                                        buttons:Ext.Msg.OK,
                                                        fn:function(btn){                                       
                                                        OrderHospStore.load({ 
                                                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                                            callback: function(r, options, success){
                                                                if(success){
                                                                }
                                                                else{
                                                                    Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:"医嘱项关联医院加载失败!",
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                        }
                                                                }
                                                        });  
                                                        Ext.getCmp("txtHospital").reset();
                                                        HospStr="";
                                                    }
                                            });                         
                                    }else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:jsonData.info,
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            }
                                     }else{
                                          Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"医嘱项关联医院修改失败!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                          Ext.getCmp("txtHospital").reset();
                                          HospStr="";
                                    }
                            }
                        })
                    }    
                };
                
    /**********************************医院关联的输入框面板************************************************/  
    var HospitalPanel=new Ext.form.FormPanel({
            region:'north',
            height:125,
            labelAlign : 'right',
            frame:true,
            items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                title:'医院关联',
                items : [{
                        columnWidth : .5,  
                        layout : "form",  
                        items : [{
                        fieldLabel: '医院',
                        xtype:'bdpcombo',
                        loadByIdParam : 'rowid',
                        name : 'HospitalDR',
                        id:'txtHospital',
                        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtHospital')),  
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtHospital'),
                        store : new Ext.data.Store({
                                proxy : new Ext.data.HttpProxy({ url : Hosp_Comp_QUERY_ACTION_URL }),
                                reader : new Ext.data.JsonReader({
                                            totalProperty : 'total',
                                            root : 'data',
                                            successProperty : 'success'
                                    }, [ 'HOSPRowId', 'HOSPDesc' ])
                        }),
                        queryParam : 'desc',
                        triggerAction : 'all',
                        forceSelection : true,
                        selectOnFocus : false,
                        minChars : 0,
                        listWidth : 250,
                        valueField : 'HOSPRowId',
                        displayField : 'HOSPDesc',
                        hiddenName : 'HospitalDR',
                        pageSize : Ext.BDP.FunLib.PageSize.Combo
                    }]
                }]
            }]
        }],
            buttonAlign:'center', 
            buttons:[{  
                    id:'btn_AddOrderHosp',
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderHosp')||(((DataType=='S')||(DataType=='A'))?true:false)),
                    text:'添加',
                    iconCls : 'icon-add',
                    width: 60,
                    handler: function (){
                        if(arcimrowid!="")
                        {
                            AddOrderHosp();
                        }
                        else{ 
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            }
                     }
             },  {  
                    id:'btn_EditOrderHosp',
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderHosp')||(((DataType=='S')||(DataType=='A'))?true:false)),  //判断功能元素授+ 私有/绝对私有时禁用按钮
                    text:'修改',
                    iconCls : 'icon-update',
                    width: 60,
                    handler: function (){ 
                    if (arcimrowid!=""){
                         EditOrderHosp();
                    }
                    else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项!',
                                        minWidth:200,
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                        }
                   }
                }, {  
                    id:'DeleteOrderHosp_del_btn',
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('DeleteOrderHosp_del_btn')||(((DataType=='S')||(DataType=='A'))?true:false)),  //判断功能元素授+ 私有/绝对私有时禁用按钮
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    handler: function (){ 
                        if(OrderHospList.selModel.hasSelection()){
                            var gsm = OrderHospList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                var DelHospRowid=rows[0].get('HOSPRowId');
                                if(DelHospRowid==""){  
                                 
                                 }
                                else{
                                    Ext.Ajax.request({
                                            url:DeleteHosp_ACTION_URL,
                                            method:'POST',
                                            params:{
                                                    'rowid':rows[0].get('HOSPRowId')
                                            },
                                            callback:function(options, success, response){
                                            Ext.MessageBox.hide();
                                            if(success){
                                                var jsonData = Ext.util.JSON.decode(response.responseText);
                                                if(jsonData.success == 'true'){
                                                    Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:'数据删除成功!',
                                                                    icon:Ext.Msg.INFO,
                                                                    buttons:Ext.Msg.OK,
                                                                    fn:function(btn){
                                                                        Ext.getCmp("txtHospital").reset();
                                                                        OrderHospStore.load({ 
                                                                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid},
                                                                            callback: function(r, options, success){
                                                                                if(success){
                                                                                }
                                                                                else{
                                                                                    Ext.Msg.show({
                                                                                                    title:'提示',
                                                                                                    msg:"医嘱项关联医院加载失败!",
                                                                                                    icon:Ext.Msg.ERROR,
                                                                                                    buttons:Ext.Msg.OK
                                                                                                });
                                                                                    }
                                                                             }
                                                                        });   
                                                                    }
                                                            });
                                                        }
                                                        else{
                                                                var errorMsg ='';
                                                                if(jsonData.info){
                                                                    errorMsg='<br />错误信息:'+jsonData.info
                                                                }
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:'数据删除失败!'+errorMsg,
                                                                                minWidth:200,
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                            }
                                                    else{
                                                    Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:'异步通讯失败,请检查网络连接!',
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                        }
                                                }
                                            },this);
                                          }
                                        }
                                    },this);
                                }
                            else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:'请先选择一条医嘱项医院!',
                                                icon:Ext.Msg.WARNING,
                                                buttons:Ext.Msg.OK
                                            });
                                    }
                            }
                },{             
                    id:'btn_RefreshHosp',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshHosp'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function(){
                        Ext.getCmp("txtHospital").reset();
                        OrderHospStore.load
                        ({ 
                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                        });  
                    }
                }]
        });         
                
    var HospitalJPanel= new Ext.Panel({
        title:'医院关联',
        layout:'border',
        //frame:true,
        items:[HospitalPanel,OrderHospList]
    });
    
        
    
    ////////// 弹窗  医院关联 tab ///////////////////////////////////////////////////////////////
    var winOrderHospStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:Hosp_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },[ {name: 'HOSPRowId', mapping:'HOSPRowId',type: 'string'},
                {name:'HospDr',mapping:'HospDr',type:'string'},
                { name: 'HOSPHospitalDR', mapping:'HOSPHospitalDR',type: 'string'}      
            ])
     });
     /******************************* 医院关联的分页工具条************************************************/
     　
        var winHosppaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: winOrderHospStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        }); 
    var winOrderHospList = new Ext.grid.GridPanel({
            id:'winOrderHospList',
            region: 'center',
            width:800,
            height:700,
            closable:true,
            store: winOrderHospStore,
            trackMouseOver: true,
            columns: [
                OrderHospSm,
                { header: 'HOSPRowId', width: 80, sortable: true, dataIndex: 'HOSPRowId', hidden:true},
                { header:'HospDr',width:80,sortable:true,dataIndex:'HospDr',hidden:true},
                { header: '医院', width: 160, sortable: true, dataIndex: 'HOSPHospitalDR' }
             ],
            stripeRows: true,
            columnLines : true, 
            stateful: true,
            viewConfig: { forceFit: true },
            bbar:winHosppaging,
            stateId: 'OrderHospList'
        });
        winOrderHospList.on("rowclick",function(winOrderHospList,rowIndex,e){
            var record = winOrderHospList.getSelectionModel().getSelected();
            Ext.getCmp("txtHospital1").setRawValue(record.data['HOSPHospitalDR']);
    });  
        
     /**********************************医院关联的输入框面板************************************************/ 
    var winHospitalPanel=new Ext.form.FormPanel({
            id:'winHospitalPanel',
            region:'north',
            height:125,
            labelAlign : 'right',
            frame:true,
            items : [{
            border : false,
            items : [{
                layout : "column",
                xtype : 'fieldset',
                title:'医院关联',
        
            items : [{
                        columnWidth : .5,  
                        layout : "form", 
                        items : [{
                        fieldLabel: '医院',
                        xtype:'bdpcombo',
                        loadByIdParam : 'rowid',
                        name : 'HospitalDR',
                        id:'txtHospital1',
                        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtHospital1')), 
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtHospital1'),
                        store : new Ext.data.Store({
                                proxy : new Ext.data.HttpProxy({ url : Hosp_Comp_QUERY_ACTION_URL }),
                                reader : new Ext.data.JsonReader({
                                            totalProperty : 'total',
                                            root : 'data',
                                            successProperty : 'success'
                                    }, [ 'HOSPRowId', 'HOSPDesc' ])
                        }),
                        queryParam : 'desc',
                        triggerAction : 'all',
                        forceSelection : true,
                        selectOnFocus : false,
                        minChars : 0,
                        listWidth : 250,
                        valueField : 'HOSPRowId',
                        displayField : 'HOSPDesc',
                        hiddenName : 'HospitalDR',
                        pageSize : Ext.BDP.FunLib.PageSize.Combo
                    }/*,{
                        columnWidth : .5, 
                        layout : "form",  
                        items : []
                    }*/]
                }]
            }]
        }],
            buttonAlign:'center', 
            buttons:[{  
                    text:'添加',
                    iconCls : 'icon-add',
                    id:'btn_AddOrderHosp1',
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderHosp1')||(((DataType=='S')||(DataType=='A'))?true:false)),  //判断功能元素授+ 私有/绝对私有时禁用按钮
                    //disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderHosp1'),
                    width: 60,
                    handler: function (){
                        if(Ext.getCmp("txtHospital1").getValue()==""){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项医院",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            return ;
                        }
                        
                        
                        var validateflag = true;
                        winOrderHospStore.each(function(record){
                            if(Ext.getCmp("txtHospital1").getRawValue()==record.get('HOSPHospitalDR'))
                            {
                                validateflag = false;
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                        var _record = new Ext.data.Record({
                            'HOSPRowId':'',
                            'HOSPHospitalDR':Ext.getCmp("txtHospital1").getRawValue(),
                            'HospDr':Ext.getCmp('txtHospital1').getValue()
                        });
                        winOrderHospList.stopEditing();
                        winOrderHospStore.insert(0,_record);       
                        Ext.getCmp("txtHospital1").reset();
                        winOrderHospStore.totalLength=Ext.getCmp("winOrderHospList").getStore().getTotalCount()+1
                        Ext.getCmp("winOrderHospList").getBottomToolbar().bind(winOrderHospStore)
            }
         },
                {  
                    text:'修改',
                    iconCls : 'icon-update',
                    width: 60,
                    id:'btn_EditOrderHosp1',
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderHosp1')||(((DataType=='S')||(DataType=='A'))?true:false)),  //判断功能元素授+ 私有/绝对私有时禁用按钮
                    //disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderHosp1'),
                    handler: function (){ 
                    if(winOrderHospList.selModel.hasSelection()){
                         if(Ext.getCmp("txtHospital1").getValue()=="")
                         {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:'请先选择一条医嘱项医院!',
                                            minWidth:200,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            return;
                        }
                        
                        var myrecord = winOrderHospList.getSelectionModel().getSelected();
                        var validateflag = true;
                        winOrderHospStore.each(function(record){
                            if (myrecord!=record) 
                            {
                                if(Ext.getCmp("txtHospital1").getRawValue()==record.get('HOSPHospitalDR'))
                                {
                                    validateflag = false;
                                }
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }   
                         
                          myrecord.set('HOSPHospitalDR',Ext.getCmp('txtHospital1').getRawValue());
                          myrecord.set('OTHLLCTLOCDR',Ext.getCmp('txtHospital1').getValue());
                          Ext.getCmp("txtHospital1").reset();
                    
                    }
                     else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项医院!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                    }
                  }
                }, {  
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    disabled : (Ext.BDP.FunLib.Component.DisableFlag('winDeleteOrderHosp_del_btn')||(((DataType=='S')||(DataType=='A'))?true:false)),  //判断功能元素授+ 私有/绝对私有时禁用按钮
                    id:'winDeleteOrderHosp_del_btn',
                    //disabled : Ext.BDP.FunLib.Component.DisableFlag('winDeleteOrderHosp_del_btn'),
                    handler: function (){ 
                        if(winOrderHospList.selModel.hasSelection()){
                            var gsm = winOrderHospList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                var DelHospRowid=rows[0].get('HOSPRowId');
                                winOrderHospStore.remove(rows[0]);
                                winOrderHospStore.totalLength=Ext.getCmp("winOrderHospList").getStore().getTotalCount()-1
                                Ext.getCmp("winOrderHospList").getBottomToolbar().bind(winOrderHospStore)
                                Ext.getCmp("txtHospital1").setValue('');
                                var linenum=winOrderHospList.getSelectionModel().lastActive;  //取消选择行
                                winOrderHospList.getSelectionModel().deselectRow(linenum);
                        }
                    });
                  }
                    else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项医院!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                            }
                    }
                },{             
                    id:'btn_RefreshHosp1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshHosp1'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function(){
                        Ext.getCmp("txtHospital1").reset();
                        winOrderHospStore.load
                        ({ 
                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                        });  
                        var linenum=winOrderHospList.getSelectionModel().lastActive;  //取消选择行
                        winOrderHospList.getSelectionModel().deselectRow(linenum);
                    }
                }]
        });         
                
    var winHospitalJPanel=  new Ext.Panel({
        title:'医院关联',
        layout:'border',
        //frame:true,
        items:[winHospitalPanel,winOrderHospList]
    });
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    
     /********************************医嘱项别名的存储store********************************************************/
    var OrderAliasStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ALIAS_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },[ {name: 'ALIASRowId', mapping:'ALIASRowId',type: 'string'},
                { name: 'ALIASText', mapping:'ALIASText',type: 'string'},     
                { name: 'ALIASDateFrom',mapping:'ALIASDateFrom',type: 'string'},
                { name: 'ALIASDateTo',mapping:'ALIASDateTo', type: 'string'}
            ])
     });
    var Aliaspaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderAliasStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        });     
// create the OrderAliasList
    var OrderAliasList = new Ext.grid.GridPanel({
        id:'OrderAliasList',
        region: 'center',
        width:800,
        height:700,
        store: OrderAliasStore,
        trackMouseOver: true,
        columns: [
                new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20}),
                { header: 'ALIASRowId', width: 80, sortable: true, dataIndex: 'ALIASRowId', hidden:true},
                { header: '医嘱项别名', width: 160, sortable: true, dataIndex: 'ALIASText' },
                { header: '开始日期', width: 100, sortable: true, dataIndex: 'ALIASDateFrom' },
                { header: '结束日期', width: 100, sortable: true, dataIndex: 'ALIASDateTo' }    
             ],
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
              singleSelect: true,
              listeners: {
                    rowselect: function(sm, row, rec) {
                             //   Ext.getCmp("form-viceadmin").getForm().loadRecord(rec);
                     }
                  }
         }),
        columnLines : true,  
        stateful: true,
        viewConfig: { forceFit: true },
        bbar:Aliaspaging ,
        stateId: 'OrderAliasList'
    });

    //Ext.BDP.FunLib.ShowUserHabit(OrderAliasList,"User.ARCAlias");
    
    OrderAliasList.on("rowclick",function(OrderAliasList,rowIndex,e){
            var record = OrderAliasList.getSelectionModel().getSelected();
            RowId=record.data['ALIASRowId'];
            Ext.getCmp("txtorderalias").setValue(record.data['ALIASText']);
            Ext.getCmp("AliasDateFrom").setValue(record.data['ALIASDateFrom']);
            Ext.getCmp("AliasDateTo").setValue(record.data['ALIASDateTo']);
                      
   });  
  /******************************添加医嘱项别名***********************************************/
    var AddOrderAlias=function(){
           if (Ext.getCmp("txtorderalias").getValue()=="") {
                Ext.Msg.show({
                                title:'提示',
                                msg:"别名不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                Ext.getCmp("txtorderalias").focus();   
                return;
            }    
            if (Ext.getCmp("AliasDateFrom").getValue()=="") {
                Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                Ext.getCmp("AliasDateFrom").focus();
                return;
            } 
            if (Ext.getCmp("AliasDateFrom").getValue()!="" & Ext.getCmp("AliasDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("AliasDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("AliasDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"开始日期不能大于结束日期!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                    return;
                }
            }
            var addaliasset=arcimrowid+"^"+Ext.getCmp("txtorderalias").getValue()+"^"+Ext.getCmp("AliasDateFrom").getRawValue()+"^"+Ext.getCmp("AliasDateTo").getRawValue();
            
            Ext.Ajax.request({
                                url:AddOrderAlias_ACTION_URL,
                                method:'POST',
                                params:{
                                    'SaveDataStr':addaliasset   
                            },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){   
                                                
                                            
                                            OrderAliasStore.load({
                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                            });  
                                            Ext.getCmp("txtorderalias").reset();
                                            Ext.getCmp("AliasDateFrom").reset();
                                            Ext.getCmp("AliasDateFrom").setValue(TodayDate);
                                            Ext.getCmp("AliasDateTo").reset();
                                            
                                        }
                                    });                         
                                }else{
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:jsonData.info,
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                        }
                            }else{
                                    Ext.Msg.show({
                                            title:'提示',
                                            msg:"医嘱项别名添加失败!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                }
                         }
                    })
            };
    /********************************修改医嘱项别名****************************************************/
    var EditOrderAlias=function(){
            var records = OrderAliasList.selModel.getSelections();
            if (records.length=0){
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项别名!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }
            else{
            var records = OrderAliasList.selModel.getSelections();
            var AliasRowid=records[0].get('ALIASRowId');
             
            if (AliasRowid=="") { 
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项别名!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }       
            if (Ext.getCmp("txtorderalias").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"别名不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("txtorderalias").focus();  
                 return;
            }    
            if (Ext.getCmp("AliasDateFrom").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 Ext.getCmp("AliasDateFrom").focus();
                 return;
            } 
            if (Ext.getCmp("AliasDateFrom").getValue()!="" & Ext.getCmp("AliasDateTo").getValue()!="") {
                var fromdate=Ext.getCmp("AliasDateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("AliasDateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                    Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能大于结束日期!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                    return;
                }
            }
            var editaliasset=AliasRowid+"^"+Ext.getCmp("txtorderalias").getValue()+"^"+Ext.getCmp("AliasDateFrom").getRawValue()+"^"+Ext.getCmp("AliasDateTo").getRawValue()+"^"+arcimrowid;
            Ext.Ajax.request({
                                url:UpdateOrderAlias_ACTION_URL,
                                method:'POST',
                                params:{
                                    'editorderalias':editaliasset 
                                    },  
                                callback:function(options, success, response){
                                    if(success){
                                        var jsonData = Ext.util.JSON.decode(response.responseText);
                                        if(jsonData.success == 'true'){
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:jsonData.info,
                                                        icon:Ext.Msg.INFO,
                                                        buttons:Ext.Msg.OK,
                                                        fn:function(btn){                                       
                                                            OrderAliasStore.load({
                                                              params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                            });  
                                                            Ext.getCmp("txtorderalias").reset();
                                                            Ext.getCmp("AliasDateFrom").reset();
                                                            Ext.getCmp("AliasDateFrom").setValue(TodayDate);
                                                            Ext.getCmp("AliasDateTo").reset();
                                                            
                                                        }
                                                    });                         
                                        }else{
                                            Ext.Msg.show({
                                                        title:'提示',
                                                        msg:jsonData.info,
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            }
                                     }else{
                                    }
                                 }
                            })
                        }   
                };
    
    ////////////////////////////////// 医嘱项别名 tab 面板 ////////////////////////////////////////
    var ARCAliasPanel=new Ext.form.FormPanel({
            region:'north',
            frame:true,
            height:120,
            labelAlign : 'right',
            items:[{
                border:false,
                items:[{ 
                layout : "column",  
                xtype:'fieldset',
                title:'医嘱项别名',
                items : [{
                         columnWidth : .33,  
                         layout : "form",  
                         items : [{
                                    fieldLabel: '<font color=red>*</font>医嘱项别名',
                                    xtype:'textfield',  
                                    allowBlank : false,
                                    width:120,
                                    id:'txtorderalias',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtorderalias'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtorderalias'))
                                  }]
                                }, {
                                   columnWidth : .33,
                                   layout : "form",
                                   items : [{
                                                fieldLabel: '<font color=red>*</font>开始日期',
                                                xtype:'datefield',
                                                width:120,
                                                allowBlank : false,
                                                id:'AliasDateFrom',
                                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('AliasDateFrom'),
                                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AliasDateFrom')),
                                                name: 'AliasDateFrom',
                                                format: BDPDateFormat,
                                                enableKeyEvents : true,
                                                listeners : { 
                                                    'keyup' : function(field, e){ 
                                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                                    }
                                                }                 
                                         }]
                                  },{
                                     columnWidth : .33,
                                     layout : "form",
                                     items : [{
                                                fieldLabel: '结束日期',
                                                width:120,
                                                xtype:'datefield',
                                                id:'AliasDateTo',
                                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('AliasDateTo'),
                                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AliasDateTo')),
                                                name: 'AliasDateTo',
                                                format: BDPDateFormat,
                                                enableKeyEvents : true,
                                                listeners : { 
                                                    'keyup' : function(field, e){ 
                                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                                    }
                                                }
                                         }]
                                  }]
                            }]
                        }],
            buttonAlign:'center', 
            buttons:[{  
                    id:'btn_AddOrderAlias',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderAlias'),
                    text:'添加',
                    iconCls : 'icon-add',
                    width: 60,
                    handler: function (){
                    
                        if (arcimrowid!="") {
                            AddOrderAlias();
                        }else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"请先选择一条医嘱项!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                            return;
                        }
                    }
             },{  
                    id:'btn_EditOrderAlias',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderAlias'),
                    text:'修改',
                    iconCls : 'icon-update',
                    width: 60,
                    handler: function (){ 
                    if (arcimrowid=="") {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                        return;
                    }
                    if(OrderAliasList.selModel.hasSelection()){
                    
                        if(Ext.getCmp("txtorderalias").getValue()==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"别名不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            Ext.getCmp("txtorderalias").focus();
                            return ;
                        }
                        if(Ext.getCmp("AliasDateFrom").getValue()==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"开始日期不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            Ext.getCmp("AliasDateFrom").focus();
                            return ;
                        }
                        
                        
                        
                        EditOrderAlias();
                        
                       
                     }
                    
                  }
                }, {  
                    id:'DeleteOrderAlias_del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteOrderAlias_del_btn'),
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    handler: function (){ 
                        if (arcimrowid==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"请先选择一条医嘱项!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            return;
                        } 
                        if(OrderAliasList.selModel.hasSelection()){
                            var gsm = OrderAliasList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                var DelAliasRowid=rows[0].get('ALIASRowId');
                                if(DelAliasRowid==""){  
                                 
                                }
                                else{
                                    var records = OrderAliasList.selModel.getSelections();
                                    var AliasRowid=records[0].get('ALIASRowId');
                                    Ext.Ajax.request({
                                            url:DeleteOrderAlias_ACTION_URL,
                                            method:'POST',
                                            params:{
                                                    'rowid':AliasRowid
                                            },
                                            callback:function(options, success, response){
                                            Ext.MessageBox.hide();
                                            if(success){
                                                var jsonData = Ext.util.JSON.decode(response.responseText);
                                                if(jsonData.success == 'true'){
                                                    Ext.Msg.show({
                                                        title:'提示',
                                                        msg:'数据删除成功!',
                                                        icon:Ext.Msg.INFO,
                                                        buttons:Ext.Msg.OK,
                                                        fn:function(btn){
                                                            Ext.getCmp("txtorderalias").reset();
                                                            Ext.getCmp("AliasDateFrom").reset();
                                                            Ext.getCmp("AliasDateFrom").setValue(TodayDate);
                                                            Ext.getCmp("AliasDateTo").reset();
                                                            OrderAliasStore.load({ 
                                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                            });   
                                                        }
                                                });
                                            }
                                    else{
                                            var errorMsg ='';
                                            if(jsonData.info){
                                                errorMsg='<br />错误信息:'+jsonData.info
                                            }
                                            Ext.Msg.show({
                                                            title:'提示',
                                                            msg:'数据删除失败!'+errorMsg,
                                                            minWidth:200,
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                            }
                                        }
                                else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:'异步通讯失败,请检查网络连接!',
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                            }
                                    }
                                },this);
                              }
                            }
                        },this);
                    }
                    else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项别名!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                            }
                    }
                   
                },{             
                    id:'btn_RefreshAlias',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshAlias'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function()
                    {
                        Ext.getCmp("txtorderalias").reset();
                        Ext.getCmp("AliasDateFrom").reset();    
                        Ext.getCmp("AliasDateFrom").setValue(TodayDate);
                        Ext.getCmp("AliasDateTo").reset();
                        var linenum=OrderAliasList.getSelectionModel().lastActive;   
                        OrderAliasList.getSelectionModel().deselectRow(linenum)
                       
                 }
            }]
    });
    
    /////////////////////////// 弹出窗口的 别名维护tab//////////////////////////////////////////
    var winARCAliasPanel=new Ext.form.FormPanel({
            id:'winAliasPanel',
            region:'north',
            frame:true,
            height:120,
            labelAlign : 'right',
            items:[{
                border:false,
                items:[{ 
                layout : "column",  
                xtype:'fieldset',
                title:'医嘱项别名',
                items : [{
                         columnWidth : .33,  
                         layout : "form",  
                         items : [{
                                    fieldLabel: '<font color=red>*</font>医嘱项别名',
                                    xtype:'textfield',  
                                    allowBlank : false,
                                    width:120,
                                    id:'txtorderalias1',
                                    readOnly : Ext.BDP.FunLib.Component.DisableFlag('txtorderalias1'),
                                    style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('txtorderalias1'))
                                  }]
                                }, {
                                   columnWidth : .33,
                                   layout : "form",
                                   items : [{
                                                fieldLabel: '<font color=red>*</font>开始日期',
                                                xtype:'datefield',
                                                width:120,
                                                allowBlank : false,
                                                id:'AliasDateFrom1',
                                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('AliasDateFrom1'),
                                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AliasDateFrom1')),
                                                name: 'AliasDateFrom',
                                                format: BDPDateFormat,
                                                enableKeyEvents : true,
                                                listeners : { 
                                                    'keyup' : function(field, e){ 
                                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                                }}                
                                         }]
                                  },{
                                     columnWidth : .33,
                                     layout : "form",
                                     items : [{
                                                fieldLabel: '结束日期',
                                                width:120,
                                                xtype:'datefield',
                                                id:'AliasDateTo1',
                                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('AliasDateTo1'),
                                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AliasDateTo1')),
                                                name: 'AliasDateTo',
                                                format: BDPDateFormat,
                                                enableKeyEvents : true,
                                                listeners : {
                                                    'keyup' : function(field, e){
                                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                                                }}
                                         }]
                                  }]
                            }]
                        }],
            buttonAlign:'center', 
            buttons:[{  
                    id:'btn_AddOrderAlias1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderAlias1'),
                    text:'添加',
                    iconCls : 'icon-add',
                    width: 60,
                    handler: function (){
                        
                        if(Ext.getCmp("txtorderalias1").getValue()==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"别名不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            Ext.getCmp("txtorderalias1").focus();
                            return ;
                        }
                        
                        if(Ext.getCmp("AliasDateFrom1").getValue()==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"开始日期不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            Ext.getCmp("AliasDateFrom1").focus();
                            return ;
                        
                        }
                        
                        
                        if (Ext.getCmp("AliasDateFrom1").getValue()!="" & Ext.getCmp("AliasDateTo1").getValue()!="") {
                            var fromdate=Ext.getCmp("AliasDateFrom1").getValue().format("Ymd");
                            var todate=Ext.getCmp("AliasDateTo1").getValue().format("Ymd");
                            if (fromdate > todate) {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"开始日期不能大于结束日期!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                return;
                            }
                        }
                        
                        var validateflag = true;
                        winOrderAliasStore.each(function(record){
                            if(Ext.getCmp("txtorderalias1").getRawValue()==record.get('ALIASText'))
                            {
                                validateflag = false;
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                        
                
                        var _record = new Ext.data.Record({
                            'ALIASRowId':'',
                            'ALIASText':Ext.getCmp("txtorderalias1").getValue(),
                            'ALIASDateFrom':Ext.getCmp('AliasDateFrom1').getRawValue(),
                            'ALIASDateTo':Ext.getCmp('AliasDateTo1').getRawValue()
                        });
                        winOrderAliasList.stopEditing();
                        winOrderAliasStore.insert(0,_record);   
                        Ext.getCmp("txtorderalias1").reset();
                        Ext.getCmp("AliasDateFrom1").reset();   
                        Ext.getCmp("AliasDateFrom1").setValue(TodayDate);
                        Ext.getCmp("AliasDateTo1").reset(); 
                        winOrderAliasStore.totalLength=Ext.getCmp("winOrderAliasList").getStore().getTotalCount()+1
                        Ext.getCmp("winOrderAliasList").getBottomToolbar().bind(winOrderAliasStore)
                        
                        
                    }
            }, { 
                    id:'btn_EditOrderAlias1',
                    text:'修改',
                    width: 60,
                    iconCls : 'icon-update',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_EditOrderAlias1'),
                    handler: function (){ 
                    if(winOrderAliasList.selModel.hasSelection()){
                        if(Ext.getCmp("AliasDateFrom1").getValue()==""){
                            Ext.Msg.show({
                                        title:'提示',
                                        msg:"开始日期不能为空!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });
                            Ext.getCmp("AliasDateFrom").focus();
                            return ;
                        }
                        if (Ext.getCmp("AliasDateFrom1").getValue()!="" & Ext.getCmp("AliasDateTo1").getValue()!="") {
                            var fromdate=Ext.getCmp("AliasDateFrom1").getValue().format("Ymd");
                            var todate=Ext.getCmp("AliasDateTo1").getValue().format("Ymd");
                            if (fromdate > todate) {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"开始日期不能大于结束日期!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                return;
                            }
                        }
                        
                        
                        var myrecord = winOrderAliasList.getSelectionModel().getSelected();
                          
                        var validateflag = true;
                        winOrderAliasStore.each(function(record){
                            if (myrecord!=record) {
                                if(Ext.getCmp("txtorderalias1").getRawValue()==record.get('ALIASText'))
                                {
                                    validateflag = false;
                                }
                            }
                        }, this); //验证新增数据是否存在
                        if(!validateflag)
                        {
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:"该记录已经存在!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                            })
                            return;
                        }
                        
                      myrecord.set('ALIASText',Ext.getCmp('txtorderalias1').getRawValue());
                      myrecord.set('ALIASDateFrom',Ext.getCmp('AliasDateFrom1').getRawValue());
                      myrecord.set('ALIASDateTo',Ext.getCmp('AliasDateTo1').getRawValue());
                      Ext.getCmp("txtorderalias1").reset();
                      Ext.getCmp("AliasDateFrom1").reset(); 
                      Ext.getCmp("AliasDateFrom1").setValue(TodayDate);
                      Ext.getCmp("AliasDateTo1").reset();  
                        
                     }
                  }
                }, {  
                    id:'winDeleteOrderAlias_del_btn',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('winDeleteOrderAlias_del_btn'),
                    text:'删除',
                    iconCls : 'icon-delete',
                    width: 60,
                    handler: function (){ 
                        if(winOrderAliasList.selModel.hasSelection()){
                            var gsm = winOrderAliasList.getSelectionModel(); 
                            var rows = gsm.getSelections(); 
                            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                            if(btn=='yes'){
                                    var DelAliasRowid=rows[0].get('ALIASRowId');
                                    winOrderAliasStore.remove(rows[0]);
                                    Ext.getCmp("txtorderalias1").setValue('');
                                    Ext.getCmp("AliasDateFrom1").setValue('');                                                                  
                                    Ext.getCmp("AliasDateTo1").setValue('');
                                    winOrderAliasStore.totalLength=Ext.getCmp("winOrderAliasList").getStore().getTotalCount()-1
                                    Ext.getCmp("winOrderAliasList").getBottomToolbar().bind(winOrderAliasStore)
                                    var linenum=winOrderAliasList.getSelectionModel().lastActive;  
                                    winOrderAliasList.getSelectionModel().deselectRow(linenum);
                            }
                        });
                    }else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'请先选择一条医嘱项别名!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         }
                     }
                },{             
                    id:'btn_RefreshAlias1',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshAlias1'),
                    text:'重置',
                    iconCls : 'icon-refresh',
                    handler:function()
                    {
                        Ext.getCmp("txtorderalias1").reset();
                        Ext.getCmp("AliasDateFrom1").reset();                                                                   
                        Ext.getCmp("AliasDateTo1").reset();
                        var linenum=winOrderAliasList.getSelectionModel().lastActive;  
                        winOrderAliasList.getSelectionModel().deselectRow(linenum)
                         
                   }
            }]
    });
    
    /*******************批量 添加 别名 *************************************************/         
    var MultiAddAlias=function(rowid){
        
        var AddAliasStr="";
        var ARCAliasCount=winOrderAliasStore.getCount();
        if (ARCAliasCount!=0){
                
                winOrderAliasStore.each(function(record){
                if(AddAliasStr!="") 
                {
                    AddAliasStr = AddAliasStr+"*";
                }
                    if(record.get('ALIASDateFrom')==""){
                        var datefrom=""
                    }
                    else{
                        var datefrom=record.get('ALIASDateFrom');
                    }
                 
                    if(record.get('ALIASDateTo')=="")   {
                        var dateto=""
                    }
                    else{
                        var dateto=record.get('ALIASDateTo');
                    }
                    AddAliasStr = AddAliasStr+record.get('ALIASText')+'^'+datefrom+'^'+dateto;
                  }, this);
        }
        else{
            AddAliasStr="";
        }
         
        Ext.Ajax.request({
            url:MultiAddAlias_URL,
            method:'POST',
            params:{
                'rowid':rowid,
                'AddAliasStr':AddAliasStr
            }   
        });  
    }
    var winOrderAliasStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ALIAS_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },[ {name: 'ALIASRowId', mapping:'ALIASRowId',type: 'string'},
                { name: 'ALIASText', mapping:'ALIASText',type: 'string'},     
                { name: 'ALIASDateFrom',mapping:'ALIASDateFrom',type: 'string'},
                { name: 'ALIASDateTo',mapping:'ALIASDateTo', type: 'string'}
            ])
     });
    
    
    var winAliaspaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: winOrderAliasStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        }); 
    /////////////////////////////// 弹出窗口的 别名列表grid//////////////////////////////////////////////////////
    var winOrderAliasList = new Ext.grid.GridPanel({
        id:'winOrderAliasList',
        region: 'center',
        width:800,
        height:700,
        store: winOrderAliasStore,
        trackMouseOver: true,
        columns: [
                new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20}),
                { header: 'ALIASRowId', width: 80, sortable: true, dataIndex: 'ALIASRowId', hidden:true},
                { header: '医嘱项别名', width: 160, sortable: true, dataIndex: 'ALIASText' },
                { header: '开始日期', width: 100, sortable: true, dataIndex: 'ALIASDateFrom' },
                { header: '结束日期', width: 100, sortable: true, dataIndex: 'ALIASDateTo' }    
             ],
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
               singleSelect: true,
               listeners: {
                            rowselect: function(sm, row, rec) {
                             //   Ext.getCmp("form-viceadmin").getForm().loadRecord(rec);
                           }
                        }
                    }),
        
        columnLines : true,  
        stateful: true,
        viewConfig: { forceFit: true },
        bbar:winAliaspaging ,
        stateId: 'OrderAliasList'
    });
    winOrderAliasList.on("rowclick",function(winOrderAliasList,rowIndex,e){
            var record = winOrderAliasList.getSelectionModel().getSelected();
            RowId=record.data['ALIASRowId'];
            Ext.getCmp("txtorderalias1").setValue(record.data['ALIASText']);
            Ext.getCmp("AliasDateFrom1").setValue(record.data['ALIASDateFrom']);
            Ext.getCmp("AliasDateTo1").setValue(record.data['ALIASDateTo']);
                      
   });  
    ///////////////// tab 页面的 别名维护 ////////////////////////////////////////////////////////////////
    var ARCAliasJPanel= new Ext.Panel({
        title:'医嘱项别名',
        layout:'border',
        region:'center',
        //frame:true,
        items:[ARCAliasPanel,OrderAliasList]
    });
    
    ////////////////////////// window 弹窗 的 tab 别名维护/////////////////////////////////////////////////
    var ARCAliasJPanel2=new Ext.Panel({
        title:'医嘱项别名',
        layout:'border',
        region:'center',
        //frame:true,
        items:[winARCAliasPanel,winOrderAliasList]
    });

    
    
    ////////////////////////////医嘱项关联医嘱项store2016-9-30
    /* ofy7 吉大三院  医嘱项关联医嘱项
    var ARCLink_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastLinkARCIM&pClassQuery=GetList";
    
     var ARCLinkds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCLink_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'ARCIMLARowId', mapping:'ARCIMLARowId',type: 'string'},
           { name: 'ARCIMLAParRef', mapping:'ARCIMLAParRef',type: 'string'},
           { name: 'ARCIMLAARCIMDR', mapping:'ARCIMLAARCIMDR',type: 'string'},
           { name: 'ARCIMLAARCIMDRID', mapping:'ARCIMLAARCIMDRID',type: 'string'},
           { name: 'ARCIMLAQty', mapping:'ARCIMLAQty',type: 'string'},
           { name: 'ARCIMLADateFrom', mapping:'ARCIMLADateFrom',type: 'string'},
           { name: 'ARCIMLADateTo',mapping:'ARCIMLADateTo',type: 'string'}
        ])
     });
     ResertLAPanel=function()
     {
         Ext.getCmp("ARCIMLAARCIMDR").reset();
         Ext.getCmp("ARCIMLAQty").reset();
         Ext.getCmp("ARCIMLADateTo").reset();
         Ext.getCmp("ARCIMLADateFrom").setValue(TodayDate);
    }
     ///////////////////////////////////添加 关联医嘱项的功能函数///////////////////////////////////
     var Save_ARCLink_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastLinkARCIM&pClassMethod=SaveData";
    var AddARCLink=function(){
        
            if (Ext.getCmp("ARCIMLAQty").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"数量不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
            if (Ext.getCmp("ARCIMLAARCIMDR").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"被关联的医嘱项不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }                        
            
            if (Ext.getCmp("ARCIMLADateFrom").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
            if (Ext.getCmp("ARCIMLADateFrom").getValue()!="" & Ext.getCmp("ARCIMLADateTo").getValue()!="") {
                var fromdate=Ext.getCmp("ARCIMLADateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("ARCIMLADateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能大于结束日期!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
                }
            }   
            var SaveDataStr=""+"^"+arcimrowid+"^"+Ext.getCmp("ARCIMLAARCIMDR").getValue()+"^"+Ext.getCmp("ARCIMLAQty").getValue()+"^"+Ext.getCmp("ARCIMLADateFrom").getRawValue()+"^"+Ext.getCmp("ARCIMLADateTo").getRawValue();
            
            Ext.Ajax.request({
                url:Save_ARCLink_ACTION_URL,
                method:'POST',
                params:{
                    'SaveDataStr':SaveDataStr    
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                            
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:'添加成功!',
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                                ARCLinkds.load({ 
                                                    params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                });  
                                                ResertLAPanel()
                                                
                                        }
                                });                         
                        }else{
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:jsonData.info,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                    }
                }else{
                     Ext.Msg.show({
                                title:'提示',
                                msg:"关联医嘱项加载失败!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                    }
                }
        })
    };  
    
    
    /// 修改关联医嘱项
    var UpdateARCLink=function(){
         
          var records=ARCLinkdsList.selModel.getSelections();
          if(records.length==0){
             Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
             return; 
         }      
        else{
            if (Ext.getCmp("ARCIMLAARCIMDR").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"被关联的医嘱项不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }
            if (Ext.getCmp("ARCIMLAQty").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"数量不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return;
            }                        
            
            if (Ext.getCmp("ARCIMLADateFrom").getValue()=="") {
                 Ext.Msg.show({
                                title:'提示',
                                msg:"开始日期不能为空!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
            if (Ext.getCmp("ARCIMLADateFrom").getValue()!="" & Ext.getCmp("ARCIMLADateTo").getValue()!="") {
                var fromdate=Ext.getCmp("ARCIMLADateFrom").getValue().format("Ymd");
                var todate=Ext.getCmp("ARCIMLADateTo").getValue().format("Ymd");
                if (fromdate > todate) {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:"开始日期不能大于结束日期!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                });
                     return;
                }
            }
            var SaveDataStr=records[0].get('ARCIMLARowId')+"^"+arcimrowid+"^"+Ext.getCmp("ARCIMLAARCIMDR").getValue()+"^"+Ext.getCmp("ARCIMLAQty").getValue()+"^"+Ext.getCmp("ARCIMLADateFrom").getRawValue()+"^"+Ext.getCmp("ARCIMLADateTo").getRawValue();        
            Ext.Ajax.request({
                    url:Save_ARCLink_ACTION_URL,
                    method:'POST',
                    params:{
                        'SaveDataStr':SaveDataStr   //更新医嘱项外部代码
                    },
                    callback:function(options, success, response){
                        if(success){
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:'数据修改成功!',
                                            icon:Ext.Msg.INFO,
                                            buttons:Ext.Msg.OK,
                                            fn:function(btn){
                                            ARCLinkds.load({ 
                                               params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                            });  
                                            ResertLAPanel()
                                                
                                        }
                                });                         
                        }else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:jsonData.info,
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                }
                           }else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:"关联医嘱项修改失败!",
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                }
                         }
                })
            }
    };
    
    //////////////////////////////////////////////////删除 关联医嘱项数据////////////////////////////////////////////////
    var DeleteARCLink_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastLinkARCIM&pClassMethod=DeleteData";
    var DeleteARCLink=function(){
         var records=ARCLinkdsList.selModel.getSelections();
          if(records.length==0){
             Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
             return; 
          }     
          else{
            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
             if(btn=='yes'){
                var records=ARCLinkdsList.selModel.getSelections();
                var ARCLinkRowid=records[0].get('ARCIMLARowId');
                Ext.Ajax.request({
                            url:DeleteARCLink_ACTION_URL,
                            method:'POST',
                            params:{
                                'id':ARCLinkRowid   
                            },
                            callback:function(options, success, response){
                                if(success){
                                        ARCLinkds.load({ 
                                            params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                        }); 
                                        ResertLAPanel()
                                }else{
                                     Ext.Msg.show({
                                                    title:'提示',
                                                    msg:"关联医嘱项删除失败!",
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                    }
                             }
                         });
                     }
            }); 
          }
    }
    
    //加载前设置参数 
    ARCLinkds.on('beforeload',function() {
                    Ext.apply(ARCLinkds.lastOptions.params, {
                        ParRef:arcimrowid
                    });
            },this);
    var ARCLinkPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: ARCLinkds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
    var ARCLinkSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    // ////////////////////////////创建 关联医嘱项grid ////////////////////////////////////////
  var ARCLinkdsList = new Ext.grid.GridPanel({
        id:'ARCLinkdsList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: ARCLinkds,
        trackMouseOver: true,
        columns: [
                ARCLinkSm,
                { header: '关联医嘱项', width: 160, sortable: true, dataIndex: 'ARCIMLAARCIMDR'},
                { header: '数量', width: 120, sortable: true, dataIndex: 'ARCIMLAQty' },
                { header: '开始日期', width: 130, sortable: true, dataIndex: 'ARCIMLADateFrom' },
                { header: '结束日期', width: 130, sortable: true, dataIndex: 'ARCIMLADateTo' },
                { header: 'ARCIMLAARCIMDRID', width: 120, sortable: true, dataIndex: 'ARCIMLAARCIMDRID', hidden:true},
                { header: 'RowId', width: 120, sortable: true, dataIndex: 'ARCIMLARowId', hidden:true}
                
                
             ],
        stripeRows: true,
        columnLines : true,  
        sm: new Ext.grid.RowSelectionModel({
                        singleSelect: true,
                        listeners: {
                            rowselect: function(sm, row, rec) {                            
                            }
                        }
                    }),
        // config options for stateful behavior
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:ARCLinkPaging,
        stateId: 'ARCLinkdsList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(ARCLinkdsList,"User.ARCItmMastLinkARCIM");
    
    //关联医嘱项
    ARCLinkdsList.on("rowclick",function(ARCLinkdsList,rowIndex,e){
        var record = ARCLinkdsList.getSelectionModel().getSelected();
                RowId=record.data['ARCIMLARowId'];
                Ext.getCmp('ARCIMLAARCIMDR').setValue(record.data['ARCIMLAARCIMDRID']); 
                Ext.getCmp('ARCIMLAARCIMDR').setRawValue(record.data['ARCIMLAARCIMDR']); 
                Ext.getCmp("ARCIMLAQty").setValue(record.data['ARCIMLAQty']);
                Ext.getCmp("ARCIMLADateFrom").setValue(record.data['ARCIMLADateFrom']);
                Ext.getCmp("ARCIMLADateTo").setValue(record.data['ARCIMLADateTo']);
              
    }); 
    
  
    
    
    var ARCLinkformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'关联医嘱项',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'ARCIMLADateFrom',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMLADateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMLADateFrom')),
                        name: 'ARCIMLADateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'ARCIMLADateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMLADateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMLADateTo')),
                        name: 'ARCIMLADateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }]
            
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>关联医嘱项',
                        id:'ARCIMLAARCIMDR',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMLAARCIMDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMLAARCIMDR')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : ARCIM_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'ARCIMRowId', 'ARCIMDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'ARCIMRowId',
                        displayField : 'ARCIMDesc'
                    }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>数量',
                        id:'ARCIMLAQty',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMLAQty'),
                        name:'ARCIMLAQty',
                        decimalPrecision:6,
                        minValue : 0,
                        allowNegative : false,//不允许输入负数
                        allowDecimals : false,//不允许输入小数
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMLAQty')),
                        xtype:'numberfield'
                    }]
                }]
            }]}
            
            ],
            
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddARCLink',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddARCLink'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    if(arcimrowid!=""){
                                        AddARCLink();
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_UpdateARCLinkds',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateARCLinkds'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                    if(arcimrowid!=""){
                                        UpdateARCLink();
                                    }
                                    else{  
                                         Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'DeleteARCLink_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('DeleteARCLink_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    if (arcimrowid!=""){
                                        DeleteARCLink();
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                                
                            },{
                                id:'btn_RefreshARCLink',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshARCLink'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        ResertLAPanel()
                                         
                                        var linenum=ARCLinkdsList.getSelectionModel().lastActive; 
                                        ARCLinkdsList.getSelectionModel().deselectRow(linenum)
                                }                 
                            }]
            
    }; 
    
    //// 创建 医嘱项关联医嘱项的显示面板
    var ARCLinkPanel=new Ext.Panel({
        layout:'border',
        title:'关联医嘱项',
        //frame:true,
        items:[ARCLinkformDetail,ARCLinkdsList]
    });
    */
    
    
    
    
    
    
    //ofy9 医嘱项关联试剂  20170608   江西上饶第五人民医院
    /*
    var ARCLinkReagent_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemReagent&pClassQuery=GetList";
    ///添加、修改医嘱项关联试剂
    var ARCLinkReagent_Save_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemReagent&pClassMethod=SaveData";
    
    var ARCLinkReagentds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCLinkReagent_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'ALRRowId', mapping:'ALRRowId',type: 'string'},
          { name: 'ALRParRef', mapping:'ALRParRef',type: 'string'},
           { name: 'ALRReagentCode', mapping:'ALRReagentCode',type: 'string'},
           { name: 'ALRReagentDesc', mapping:'ALRReagentDesc',type: 'string'},
           { name: 'ALRPrice', mapping:'ALRPrice',type: 'string'},
           { name: 'ALRQty', mapping:'ALRQty',type: 'string'},
           { name: 'ALRDateFrom', mapping:'ALRDateFrom',type: 'string'},
           { name: 'ALRDateTo',mapping:'ALRDateTo',type: 'string'}
        ])
     });
     
    
    //加载前设置参数 
    ARCLinkReagentds.on('beforeload',function() {
                    Ext.apply(ARCLinkReagentds.lastOptions.params, {
                        ParRef:arcimrowid
                    });
            },this);
            
    var ARCLinkReagentPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: ARCLinkReagentds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
   var ARCLinkReagentSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    // ////////////////////////////创建 关联试剂grid ////////////////////////////////////////
  var ARCLinkReagentList = new Ext.grid.GridPanel({
        id:'ARCLinkReagentList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: ARCLinkReagentds,
        trackMouseOver: true,
        sm: ARCLinkReagentSm,
        columns: [
                ARCLinkReagentSm,
                { header: '试剂代码', width: 160, sortable: true, dataIndex: 'ALRReagentCode'},
                { header: '试剂描述', width: 160, sortable: true, dataIndex: 'ALRReagentDesc'},
                { header: '价格', width: 140, sortable: true, dataIndex: 'ALRPrice'},
                { header: '数量', width: 140, sortable: true, dataIndex: 'ALRQty' },
                { header: '开始日期', width: 160, sortable: true, dataIndex: 'ALRDateFrom' },
                { header: '结束日期', width: 160, sortable: true, dataIndex: 'ALRDateTo' },
                { header: 'ParRef', width: 160, sortable: true, dataIndex: 'ALRParRef' , hidden:true},
                { header: 'ID', width: 120, sortable: true, dataIndex: 'ALRRowId', hidden:true}     
             ],
        stripeRows: true,
        columnLines : true,  
        
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:ARCLinkReagentPaging,
        stateId: 'ARCLinkReagentList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(ARCLinkReagentList,"User.ARCItemReagent");
    
    //关联试剂
    ARCLinkReagentList.on("rowclick",function(ARCLinkReagentList,rowIndex,e){
        var record = ARCLinkReagentList.getSelectionModel().getSelected();
                RowId=record.data['ALRRowId'];
                Ext.getCmp('ALRReagentCode').setValue(record.data['ALRReagentCode']); 
                Ext.getCmp('ALRReagentDesc').setValue(record.data['ALRReagentDesc']); 
                Ext.getCmp('ALRPrice').setValue(record.data['ALRPrice']); 
                Ext.getCmp("ALRQty").setValue(record.data['ALRQty']);
                Ext.getCmp("ALRDateFrom").setValue(record.data['ALRDateFrom']);
                Ext.getCmp("ALRDateTo").setValue(record.data['ALRDateTo']);
                
                Ext.getCmp("ALRReagentCode").disable();
                Ext.getCmp("ALRReagentDesc").disable();                                 
                Ext.getCmp("ALRPrice").disable();
                Ext.getCmp("ALRQty").disable();
                Ext.getCmp("ALRDateFrom").disable();
                
    }); 
    
   resetALRPanel=function()
   {
        Ext.getCmp("ALRReagentCode").reset();
        Ext.getCmp("ALRReagentDesc").reset();                                   
        Ext.getCmp("ALRPrice").reset();
        Ext.getCmp("ALRQty").reset();
        Ext.getCmp("ALRDateFrom").setValue(TodayDate);
        Ext.getCmp("ALRDateTo").reset();
        
        Ext.getCmp("ALRReagentCode").enable();
        Ext.getCmp("ALRReagentDesc").enable();                                  
        Ext.getCmp("ALRPrice").enable();
        Ext.getCmp("ALRQty").enable();
        Ext.getCmp("ALRDateFrom").enable();
        
        
   }
    
    
    var ARCLinkReagentformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:185,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'关联试剂',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>试剂代码',
                        id:'ALRReagentCode',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRReagentCode'),
                        name:'ALRReagentCode',
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRReagentCode')),
                        xtype:'textfield',
                        listeners :{
                            'blur':function(f){
                                var Desc=tkMakeServerCall("web.DHCBL.CT.ARCItemReagent","GetDescByCode",f.getValue());
                                if (Desc!="") Ext.getCmp('ALRReagentDesc').setValue(Desc)
                                
                            }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>试剂描述',
                        id:'ALRReagentDesc',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRReagentDesc'),
                        name:'ALRReagentDesc',
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRReagentDesc')),
                        xtype:'textfield'
                    }]
            
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>价格',
                        id:'ALRPrice',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRPrice'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRPrice')),
                        name:'ALRPrice',
                        minValue : 0,
                        allowNegative : false,//不允许输入负数
                        xtype:'numberfield'
                    },{
                        fieldLabel: '<font color=red>*</font>数量',
                        id:'ALRQty',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRQty'),
                        name:'ALRQty',
                        decimalPrecision:6,  //小数点后几位
                        minValue : 0,
                        allowNegative : false,//不允许输入负数
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRQty')),
                        xtype:'numberfield'
                    }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'ALRDateFrom',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRDateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRDateFrom')),
                        name: 'ALRDateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }               
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'ALRDateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRDateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRDateTo')),
                        name: 'ALRDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }]
                }]
            }]}
            
            ],
            
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddARCLinkReagent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddARCLinkReagent'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    if(arcimrowid!=""){
                                        if (Ext.getCmp("ALRReagentCode").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"试剂代码不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("ALRReagentDesc").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"试剂描述不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("ALRQty").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"数量不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("ALRPrice").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"价格不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }                        
                                        
                                        if (Ext.getCmp("ALRDateFrom").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                            return;
                                        }
                                        
                                        if ( Ext.getCmp("ALRDateFrom").getValue()!="") {
                                            var fromdate=Ext.getCmp("ALRDateFrom").getValue().format("Ymd");
                                            var toadydate=(new Date()).format("Ymd");
                                            if (toadydate > fromdate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能早于今天!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }   
                                        if (Ext.getCmp("ALRDateFrom").getValue()!="" & Ext.getCmp("ALRDateTo").getValue()!="") {
                                            var fromdate=Ext.getCmp("ALRDateFrom").getValue().format("Ymd");
                                            var todate=Ext.getCmp("ALRDateTo").getValue().format("Ymd");
                                            if (fromdate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能大于结束日期!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        if ( Ext.getCmp("ALRDateTo").getValue()!="") {
                                            var todate=Ext.getCmp("ALRDateTo").getValue().format("Ymd");
                                            var toadydate=(new Date()).format("Ymd");
                                            if (toadydate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"结束日期不能早于今天!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        
                                        
                                        /// 1 ALRRowId ，2 ParRef  ，3 试剂代码， 4 试剂描述 ， 5 价格  ，6 数量，7 开始日期，8 结束日期
                                        var SaveDataStr=""+"^"+arcimrowid+"^"+Ext.getCmp("ALRReagentCode").getValue()+"^"+Ext.getCmp("ALRReagentDesc").getValue()+"^"+Ext.getCmp("ALRPrice").getValue()+"^"+Ext.getCmp("ALRQty").getValue()+"^"+Ext.getCmp("ALRDateFrom").getRawValue()+"^"+Ext.getCmp("ALRDateTo").getRawValue();
                                        
                                        Ext.Ajax.request({
                                            url:ARCLinkReagent_Save_ACTION_URL,
                                            method:'POST',
                                            params:{
                                                'SaveDataStr':SaveDataStr    
                                            },
                                            callback:function(options, success, response){
                                                if(success){
                                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                                    if(jsonData.success == 'true'){
                                                        
                                                        Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:'添加成功!',
                                                                        icon:Ext.Msg.INFO,
                                                                        buttons:Ext.Msg.OK,
                                                                        fn:function(btn){
                                                                            ARCLinkReagentds.load({ 
                                                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                                            });  
                                                                            resetALRPanel()
                                                                            
                                                                    }
                                                            });                         
                                                    }else{
                                                        Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:jsonData.errorinfo,
                                                                        icon:Ext.Msg.ERROR,
                                                                        buttons:Ext.Msg.OK
                                                                    });
                                                                }
                                            }else{
                                                 Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"关联试剂添加失败!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                                }
                                            }
                                    })
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_UpdateARCLinkReagent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateARCLinkReagent'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                    if(arcimrowid!=""){
                                          if(!ARCLinkReagentList.selModel.hasSelection()){
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"请先选择一条关联试剂!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return; 
                                         }      
                                        else{
                                            //var records=ARCLinkReagentList.selModel.getSelections();
                                            var records=ARCLinkReagentList.getSelectionModel().getSelections()
                                            if (Ext.getCmp("ALRReagentCode").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"试剂代码不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            if (Ext.getCmp("ALRReagentDesc").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"试剂描述不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                        
                                            if (Ext.getCmp("ALRPrice").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"价格不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                return;
                                            }
                                            if (Ext.getCmp("ALRQty").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"数量不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }                        
                                            
                                            if (Ext.getCmp("ALRDateFrom").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            
                                            if (Ext.getCmp("ALRDateFrom").getValue()!="" & Ext.getCmp("ALRDateTo").getValue()!="") {
                                                var fromdate=Ext.getCmp("ALRDateFrom").getValue().format("Ymd");
                                                var todate=Ext.getCmp("ALRDateTo").getValue().format("Ymd");
                                                if (fromdate > todate) {
                                                     Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:"开始日期不能大于结束日期!",
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                     return;
                                                }
                                            }
                                            
                                            if ( Ext.getCmp("ALRDateTo").getValue()!="") {
                                                var todate=Ext.getCmp("ALRDateTo").getValue().format("Ymd");
                                                var toadydate=(new Date()).format("Ymd");
                                                if (toadydate > todate) {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"结束日期不能早于今天!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                                }
                                            }
                                            
                                            /// 1 ALRRowId ，2 ParRef  ，3 试剂代码， 4 试剂描述 ， 5 价格  ，6 数量，7 开始日期，8 结束日期
                                            var SaveDataStr=records[0].get('ALRRowId')+"^"+arcimrowid+"^"+Ext.getCmp("ALRReagentCode").getValue()+"^"+Ext.getCmp("ALRReagentDesc").getValue()+"^"+Ext.getCmp("ALRPrice").getValue()+"^"+Ext.getCmp("ALRQty").getValue()+"^"+Ext.getCmp("ALRDateFrom").getRawValue()+"^"+Ext.getCmp("ALRDateTo").getRawValue();
                                            
                                            Ext.Ajax.request({
                                                    url:ARCLinkReagent_Save_ACTION_URL,
                                                    method:'POST',
                                                    params:{
                                                        'SaveDataStr':SaveDataStr 
                                                    },
                                                    callback:function(options, success, response){
                                                        if(success){
                                                            var jsonData = Ext.util.JSON.decode(response.responseText);
                                                            if(jsonData.success == 'true'){
                                                            Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:'修改成功!',
                                                                        icon:Ext.Msg.INFO,
                                                                        buttons:Ext.Msg.OK,
                                                                        fn:function(btn){
                                                                            ARCLinkReagentds.load({ 
                                                                               params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                                            });  
                                                                            resetALRPanel
                                                                        }
                                                                });                         
                                                        }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:jsonData.errorinfo,
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                           }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:"关联试剂修改失败!",
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                         }
                                                })
                                            }
                                    }
                                    else{  
                                         Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_RefreshARCLinkReagent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshARCLinkReagent'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        Ext.getCmp("ALRReagentCode").reset();
                                        Ext.getCmp("ALRReagentDesc").reset();                                   
                                        Ext.getCmp("ALRPrice").reset();
                                        Ext.getCmp("ALRQty").reset();
                                        Ext.getCmp("ALRDateFrom").setValue(TodayDate);
                                        Ext.getCmp("ALRDateTo").reset();
                                        
                                        Ext.getCmp("ALRReagentCode").enable();
                                        Ext.getCmp("ALRReagentDesc").enable();                                  
                                        Ext.getCmp("ALRPrice").enable();
                                        Ext.getCmp("ALRQty").enable();
                                        Ext.getCmp("ALRDateFrom").enable();
                                        Ext.getCmp("ALRDateTo").enable();
                                        
                                        var linenum=ARCLinkReagentList.getSelectionModel().lastActive; 
                                        ARCLinkReagentList.getSelectionModel().deselectRow(linenum)
                                }                 
                            }]
            
    }; 
    
    //// 创建医嘱项关联试剂的显示面板
    var ARCLinkReagentPanel=new Ext.Panel({
        layout:'border',
        title:'关联试剂',
        //frame:true,
        items:[ARCLinkReagentformDetail,ARCLinkReagentList]
    });
    */
    ///ofy9
    
    
    //ofy10 医嘱项项目依赖  20170916 医生站要求
    /*
    var ARCItemDependent_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemDependent&pClassQuery=GetList";
    ///添加、修改
    var ARCItemDependent_Save_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemDependent&pClassMethod=SaveData";
    ////删除
    var ARCItemDependent_DeleteData_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemDependent&pClassMethod=DeleteData";
                                        
    var ARCItemDependent_UOM_QUERY_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemDependent&pClassMethod=GetUnitDataForCmb1";
    
    var ARCItemDependentds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCItemDependent_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'DEPRowId', mapping:'DEPRowId',type: 'string'},
           { name: 'DEPParRef', mapping:'DEPParRef',type: 'string'},
           { name: 'DEPARCIMDR', mapping:'DEPARCIMDR',type: 'string'},
           { name: 'DEPUnitDR', mapping:'DEPUnitDR',type: 'string'},
           { name: 'DEPARCIMDRID', mapping:'DEPARCIMDRID',type: 'string'},
           { name: 'DEPUnitDRID', mapping:'DEPUnitDRID',type: 'string'},
           { name: 'DEPDoseQty', mapping:'DEPDoseQty',type: 'string'},
           { name: 'DEPDateFrom', mapping:'DEPDateFrom',type: 'string'},
           { name: 'DEPDateTo',mapping:'DEPDateTo',type: 'string'}
        ])
     });
     
    ARCItemDependentds.on('beforeload',function() {
                    Ext.apply(ARCItemDependentds.lastOptions.params, {
                        ParRef:arcimrowid
                    });
            },this);
            
    var ARCItemDependentPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: ARCItemDependentds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
   var ARCItemDependentSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    
   var ARCItemDependentList = new Ext.grid.GridPanel({
        id:'ARCItemDependentList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: ARCItemDependentds,
        trackMouseOver: true,
        sm: ARCItemDependentSm,
        columns: [
                  new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
                ARCItemDependentSm,
                new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
                { header: '医嘱项目', width: 160, sortable: true, dataIndex: 'DEPARCIMDR'},
                { header: '医嘱项目ID', width: 160, sortable: true, dataIndex: 'DEPARCIMDRID', hidden:true},
                { header: '单位', width: 160, sortable: true, dataIndex: 'DEPUnitDR'},
                { header: '单位ID', width: 160, sortable: true, dataIndex: 'DEPUnitDRID', hidden:true},
                { header: '数量', width: 160, sortable: true, dataIndex: 'DEPDoseQty' },
                { header: '开始日期', width: 160, sortable: true, dataIndex: 'DEPDateFrom' },
                { header: '结束日期', width: 160, sortable: true, dataIndex: 'DEPDateTo' },
                { header: 'ParRef', width: 160, sortable: true, dataIndex: 'DEPParRef' , hidden:true},
                { header: 'DEPRowId', width: 120, sortable: true, dataIndex: 'DEPRowId', hidden:true}     
             ],
        stripeRows: true,
        columnLines : true,
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:ARCItemDependentPaging,
        stateId: 'ARCItemDependentList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(ARCItemDependentList,"User.ARCItemDependent");
    
    
    ARCItemDependentList.on("rowclick",function(ARCItemDependentList,rowIndex,e){
        var record = ARCItemDependentList.getSelectionModel().getSelected();
                 DEPUnitDRds.baseParams = {
                    ARCIMRowId:record.data['DEPARCIMDRID']
                };
                DEPUnitDRds.load()
                RowId=record.data['DEPRowId'];
                Ext.getCmp('DEPARCIMDR').setValue(record.data['DEPARCIMDRID']); 
                Ext.getCmp('DEPUnitDR').setValue(record.data['DEPUnitDRID']); 
                Ext.getCmp("DEPDoseQty").setValue(record.data['DEPDoseQty']);
                Ext.getCmp("DEPDateFrom").setValue(record.data['DEPDateFrom']);
                Ext.getCmp("DEPDateTo").setValue(record.data['DEPDateTo']);
                
                
    }); 
    
   resetDEPPanel=function()
   {
        Ext.getCmp("DEPARCIMDR").reset();                                   
        Ext.getCmp("DEPUnitDR").setValue(DefUnit);
        Ext.getCmp("DEPDoseQty").reset();
        Ext.getCmp("DEPDateFrom").setValue(TodayDate);
        Ext.getCmp("DEPDateTo").reset();    
   }
   
   
   var DEPUnitDRds=new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : ARCItemDependent_UOM_QUERY_ACTION_URL }),
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [ 'RowId', 'Desc' ])
            })
    DEPUnitDRds.on('beforeload',function(){
            ARCIMRowId:Ext.getCmp("DEPARCIMDR").getValue()
    });
    var DEP_ARCIM_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemDependent&pClassMethod=GetDataForCmb3";
    
    var DefUnit=tkMakeServerCall("web.DHCBL.CT.ARCItemDependent","GetDefUnit")
    
    var ARCItemDependentformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:155,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'医嘱项项目依赖',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>医嘱项目',
                        id:'DEPARCIMDR',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DEPARCIMDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DEPARCIMDR')),
                        allowBlank : false,
                        store : new Ext.data.Store({
                            proxy : new Ext.data.HttpProxy({ url : DEP_ARCIM_QUERY_ACTION_URL }),
                            reader : new Ext.data.JsonReader({
                                        totalProperty : 'total',
                                        root : 'data',
                                        successProperty : 'success'
                                    }, [ 'ARCIMRowId', 'ARCIMDesc' ])
                        }),
                        mode : 'remote',
                        queryParam : 'desc',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'ARCIMRowId',
                        displayField : 'ARCIMDesc',
                        listeners:{
                             'select': function(field,e){
                                    DEPUnitDRds.baseParams = {
                                        ARCIMRowId:Ext.getCmp("DEPARCIMDR").getValue()
                                    };
                                    DEPUnitDRds.load()
                                }
                             }  
                    },{
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'DEPDateFrom',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DEPDateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DEPDateFrom')),
                        name: 'DEPDateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }   
                    }]
            
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        xtype : 'bdpcombo',
                        fieldLabel : '<font color=red>*</font>单位',
                        id:'DEPUnitDR',
                        loadByIdParam : 'rowid',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DEPUnitDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DEPUnitDR')),
                        allowBlank : false,
                        store : DEPUnitDRds,
                        mode : 'remote',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'RowId',
                        displayField : 'Desc'
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'DEPDateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DEPDateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DEPDateTo')),
                        name: 'DEPDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>数量',
                        id:'DEPDoseQty',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('DEPDoseQty'),
                        name:'DEPDoseQty',
                        decimalPrecision:6,  //小数点后几位
                        minValue : 0,
                        allowNegative : false,//不允许输入负数
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DEPDoseQty')),
                        xtype:'numberfield'         
                    }]
                }]
            }]}
            
            ],
            
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddARCItemDependent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddARCItemDependent'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    if(arcimrowid!=""){
                                        if (Ext.getCmp("DEPARCIMDR").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"医嘱项目不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("DEPDoseQty").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"数量必须大于0!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("DEPUnitDR").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"单位不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }                        
                                        
                                        if (Ext.getCmp("DEPDateFrom").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                            return;
                                        }
                                        
                                     
                                        if (Ext.getCmp("DEPDateFrom").getValue()!="" & Ext.getCmp("DEPDateTo").getValue()!="") {
                                            var fromdate=Ext.getCmp("DEPDateFrom").getValue().format("Ymd");
                                            var todate=Ext.getCmp("DEPDateTo").getValue().format("Ymd");
                                            if (fromdate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能大于结束日期!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        if ( Ext.getCmp("DEPDateTo").getValue()!="") {
                                            var todate=Ext.getCmp("DEPDateTo").getValue().format("Ymd");
                                            var toadydate=(new Date()).format("Ymd");
                                            if (toadydate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"结束日期不能早于今天!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        
                                        /// 1 DEPRowId ，2 ParRef  ，3 医嘱项目， 4 单位 ， 5数量  ，6 开始日期，7 结束日期
                                        var SaveDataStr=""+"^"+arcimrowid+"^"+Ext.getCmp("DEPARCIMDR").getValue()+"^"+Ext.getCmp("DEPUnitDR").getValue()+"^"+Ext.getCmp("DEPDoseQty").getValue()+"^"+Ext.getCmp("DEPDateFrom").getRawValue()+"^"+Ext.getCmp("DEPDateTo").getRawValue();
                                        Ext.Ajax.request({
                                                url:ARCItemDependent_Save_ACTION_URL,
                                                method:'POST',
                                                params:{
                                                    'SaveDataStr':SaveDataStr    
                                                },
                                                callback:function(options, success, response){
                                                    if(success){
                                                        var jsonData = Ext.util.JSON.decode(response.responseText);
                                                        if(jsonData.success == 'true'){
                                                            Ext.Msg.show({
                                                                            title:'提示',
                                                                            msg:'添加成功!',
                                                                            icon:Ext.Msg.INFO,
                                                                            buttons:Ext.Msg.OK,
                                                                            fn:function(btn){
                                                                                ARCItemDependentds.load({ 
                                                                                    params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                                                });  
                                                                                resetDEPPanel()
                                                                                
                                                                        }
                                                                });                         
                                                        }else{
                                                            Ext.Msg.show({
                                                                            title:'提示',
                                                                            msg:jsonData.errorinfo,
                                                                            icon:Ext.Msg.ERROR,
                                                                            buttons:Ext.Msg.OK
                                                                        });
                                                                    }
                                                }else{
                                                     Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"添加失败!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                    }
                                                }
                                        })
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_UpdateARCItemDependent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateARCItemDependent'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                    if(arcimrowid!=""){
                                         if(!ARCItemDependentList.selModel.hasSelection()){
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"请先选择一条数据!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return; 
                                         }      
                                         else{
                                            
                                            if (Ext.getCmp("DEPARCIMDR").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"医嘱项目不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            if (Ext.getCmp("DEPUnitDR").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"单位不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                        
                                            if (Ext.getCmp("DEPDoseQty").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"数量不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }                        
                                            
                                            if (Ext.getCmp("DEPDateFrom").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            
                                            if (Ext.getCmp("DEPDateFrom").getValue()!="" & Ext.getCmp("DEPDateTo").getValue()!="") {
                                                var fromdate=Ext.getCmp("DEPDateFrom").getValue().format("Ymd");
                                                var todate=Ext.getCmp("DEPDateTo").getValue().format("Ymd");
                                                if (fromdate > todate) {
                                                     Ext.Msg.show({
                                                                    title:'提示',
                                                                    msg:"开始日期不能大于结束日期!",
                                                                    icon:Ext.Msg.ERROR,
                                                                    buttons:Ext.Msg.OK
                                                                });
                                                     return;
                                                }
                                            }
                                            
                                            if ( Ext.getCmp("DEPDateTo").getValue()!="") {
                                                var todate=Ext.getCmp("DEPDateTo").getValue().format("Ymd");
                                                var toadydate=(new Date()).format("Ymd");
                                                if (toadydate > todate) {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"结束日期不能早于今天!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                                }
                                            }
                                            //var records=ARCItemDependentList.selModel.getSelections();
                                            var records=ARCItemDependentList.getSelectionModel().getSelections()
                                            /// 1 DEPRowId ，2 ParRef  ，3 医嘱项目， 4 单位 ， 5数量  ，6 开始日期，7 结束日期
                                            var SaveDataStr=records[0].get('DEPRowId')+"^"+arcimrowid+"^"+Ext.getCmp("DEPARCIMDR").getValue()+"^"+Ext.getCmp("DEPUnitDR").getValue()+"^"+Ext.getCmp("DEPDoseQty").getValue()+"^"+Ext.getCmp("DEPDateFrom").getRawValue()+"^"+Ext.getCmp("DEPDateTo").getRawValue();
                                            
                                            Ext.Ajax.request({
                                                    url:ARCItemDependent_Save_ACTION_URL,
                                                    method:'POST',
                                                    params:{
                                                        'SaveDataStr':SaveDataStr 
                                                    },
                                                    callback:function(options, success, response){
                                                        if(success){
                                                            var jsonData = Ext.util.JSON.decode(response.responseText);
                                                            if(jsonData.success == 'true'){
                                                            Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:'修改成功!',
                                                                        icon:Ext.Msg.INFO,
                                                                        buttons:Ext.Msg.OK,
                                                                        fn:function(btn){
                                                                            ARCItemDependentds.load({ 
                                                                               params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                                            });  
                                                                            resetDEPPanel()
                                                                        }
                                                                });                         
                                                        }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:jsonData.errorinfo,
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                           }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:"修改失败!",
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                         }
                                                })
                                            }
                                    }
                                    else{  
                                         Ext.Msg.show({
                                                title:'提示',
                                                msg:"请先选择一条医嘱项!",
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                         return;
                                    }
                                }
                            },{
                                id:'ARCItemDependent_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('ARCItemDependent_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    if (arcimrowid!=""){
                                            if(!ARCItemDependentList.selModel.hasSelection()){
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"请先选择一条数据!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return; 
                                             }
                                             else{
                                                Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                                                 if(btn=='yes'){
                                                    var records=ARCItemDependentList.selModel.getSelections();
                                                    Ext.Ajax.request({
                                                                url:ARCItemDependent_DeleteData_ACTION_URL,
                                                                method:'POST',
                                                                params:{
                                                                    'id':records[0].get('DEPRowId')   
                                                                },
                                                                callback:function(options, success, response){
                                                                    if(success){
                                                                            ARCItemDependentds.load({ 
                                                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                                            }); 
                                                                            ResertDEPPanel()
                                                                    }else{
                                                                         Ext.Msg.show({
                                                                                        title:'提示',
                                                                                        msg:"关联医嘱项删除失败!",
                                                                                        icon:Ext.Msg.ERROR,
                                                                                        buttons:Ext.Msg.OK
                                                                                    });
                                                                        }
                                                                 }
                                                             });
                                                         }
                                                }); 
                                              }
                                        
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                                
                            },{
                                
                                id:'btn_RefreshARCItemDependent',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshARCItemDependent'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        Ext.getCmp("DEPARCIMDR").reset();
                                        Ext.getCmp("DEPUnitDR").setValue(DefUnit);
                                        Ext.getCmp("DEPDoseQty").reset();
                                        Ext.getCmp("DEPDateFrom").setValue(TodayDate);
                                        Ext.getCmp("DEPDateTo").reset();
                                        
                                        var linenum=ARCItemDependentList.getSelectionModel().lastActive; 
                                        ARCItemDependentList.getSelectionModel().deselectRow(linenum)
                                }                 
                            }]
            
    }; 
    
    
    var ARCItemDependentPanel=new Ext.Panel({
        layout:'border',
        title:'项目依赖',
        //frame:true,
        items:[ARCItemDependentformDetail,ARCItemDependentList]
    });
    */
    ///ofy10
    
    
    
    //ofy11 医嘱项位点  20170914中日友好医院
    /*
    var ARCItemLocus_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemLocus&pClassQuery=GetList";
    ///添加、修改
    var ARCItemLocus_Save_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemLocus&pClassMethod=SaveData";
    ////删除
    var ARCItemLocus_DeleteData_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemLocus&pClassMethod=DeleteData";
                                        
    var ARCItemLocus_ARCIM_QUERY_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemLocus&pClassMethod=GetARCIMDataForCmb1";
    
    var ARCItemLocusds = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ARCItemLocus_ACTION_URL}), 
        reader: new Ext.data.JsonReader({
                totalProperty: 'total',
                root: 'data',
                successProperty :'success'
            },
          [{ name: 'LOCUSRowId', mapping:'LOCUSRowId',type: 'string'},
           { name: 'LOCUSParRef', mapping:'LOCUSParRef',type: 'string'},
           { name: 'LOCUSPoint', mapping:'LOCUSPoint',type: 'string'},
           { name: 'LOCUSARCIMDR', mapping:'LOCUSARCIMDR',type: 'string'},
           { name: 'LOCUSARCIMDRID', mapping:'LOCUSARCIMDRID',type: 'string'},
           { name: 'LOCUSRequired', mapping:'LOCUSRequired',type: 'string'},
           { name: 'LOCUSDateFrom', mapping:'LOCUSDateFrom',type: 'string'},
           { name: 'LOCUSDateTo',mapping:'LOCUSDateTo',type: 'string'}
        ])
     });
     
    ARCItemLocusds.on('beforeload',function() {
                    Ext.apply(ARCItemLocusds.lastOptions.params, {
                        ParRef:arcimrowid
                    });
            },this);
            
    var ARCItemLocusPaging= new Ext.PagingToolbar({
            pageSize: 20,
            store: ARCItemLocusds,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录 一共 {2} 条',
            emptyMsg: "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
                "change":function (t,p) {
                    pagesize_pop=this.pageSize;
                }
            }
        })      
   var ARCItemLocusSm = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    
   var ARCItemLocusList = new Ext.grid.GridPanel({
        id:'ARCItemLocusList',
        region: 'center',
        width:800,
        height:700,
        autoScroll:true,
        store: ARCItemLocusds,
        trackMouseOver: true,
        sm: ARCItemLocusSm,
        columns: [
                ARCItemLocusSm,
                { header: '位点', width: 160, sortable: true, dataIndex: 'LOCUSPoint' },
                { header: '医嘱项目', width: 160, sortable: true, dataIndex: 'LOCUSARCIMDR'},
                { header: '医嘱项目ID', width: 160, sortable: true, dataIndex: 'LOCUSARCIMDRID', hidden:true},
                { header: '是否必填', width: 160, sortable: true, dataIndex: 'LOCUSRequired',renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                { header: '开始日期', width: 160, sortable: true, dataIndex: 'LOCUSDateFrom' },
                { header: '结束日期', width: 160, sortable: true, dataIndex: 'LOCUSDateTo' },
                { header: 'ParRef', width: 160, sortable: true, dataIndex: 'DEPParRef' , hidden:true},
                { header: 'DEPRowId', width: 120, sortable: true, dataIndex: 'DEPRowId', hidden:true}     
             ],
        stripeRows: true,
        columnLines : true,
        stateful: true,
        viewConfig: {
             forceFit: true
        },
        bbar:ARCItemLocusPaging,
        stateId: 'ARCItemLocusList'
    });
    
    //Ext.BDP.FunLib.ShowUserHabit(ARCItemLocusList,"User.ARCItemLocus");
    
    
    ARCItemLocusList.on("rowclick",function(ARCItemLocusList,rowIndex,e){
                var record = ARCItemLocusList.getSelectionModel().getSelected();
                Ext.getCmp("LOCUSPoint").setValue(record.data['LOCUSPoint']);
                Ext.getCmp('LOCUSARCIMDR').setValue(record.data['LOCUSARCIMDRID']); 
                Ext.getCmp('LOCUSRequired').setValue((record.get('LOCUSRequired'))=='Y'?true:false);
                Ext.getCmp("LOCUSDateFrom").setValue(record.data['LOCUSDateFrom']);
                Ext.getCmp("LOCUSDateTo").setValue(record.data['LOCUSDateTo']);
                
                
    }); 
    
   resetLOCUSPanel=function()
   {
        Ext.getCmp("LOCUSARCIMDR").reset();                                 
        Ext.getCmp("LOCUSPoint").reset();
        Ext.getCmp("LOCUSRequired").setValue(false);
        Ext.getCmp("LOCUSDateFrom").setValue(TodayDate);
        Ext.getCmp("LOCUSDateTo").reset();  
   }
   
   
   var LOCUSARCIMds=new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : ARCItemLocus_ARCIM_QUERY_ACTION_URL }),
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [ 'ARCIMRowId', 'ARCIMDesc' ])
            })
    LOCUSARCIMds.on('beforeload',function(){
            point:Ext.getCmp("LOCUSPoint").getValue()
    });
    
    
    var ARCItemLocusformDetail = {
        xtype:"form",
        region:"north", 
        frame:true,
        height:155,
        labelAlign : 'right',
        items:[{
            xtype:'fieldset',
            title:'医嘱项位点',
            items:[{
                layout:'column',
                border:false,
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>位点',
                        id:'LOCUSPoint',
                        allowBlank : false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCUSPoint'),
                        name:'LOCUSPoint',
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCUSPoint')),
                        xtype:'textfield',
                        listeners:{
                             'blur': function(field,e){
                                    LOCUSARCIMds.baseParams = {
                                        point:Ext.getCmp("LOCUSPoint").getValue()
                                    };
                                    LOCUSARCIMds.load()
                                }
                             }          
                    },{
                        
                        fieldLabel: '<font color=red>*</font>开始日期',
                        xtype:'datefield',
                        allowBlank : false,
                        id:'LOCUSDateFrom',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCUSDateFrom'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCUSDateFrom')),
                        name: 'LOCUSDateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }   
                    }]
            
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                    
                        xtype : 'bdpcombo',
                        loadByIdParam : 'rowid',
                        fieldLabel : '<font color=red>*</font>医嘱项目',
                        id:'LOCUSARCIMDR',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCUSARCIMDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCUSARCIMDR')),
                        allowBlank : false,
                        store : LOCUSARCIMds,
                        mode : 'remote',
                        queryParam : 'desc',
                        forceSelection : true,
                        selectOnFocus : false, 
                        minChars : 0,
                        listWidth:250,
                        pageSize :Ext.BDP.FunLib.PageSize.Combo,  
                        valueField : 'ARCIMRowId',
                        displayField : 'ARCIMDesc'
                    
                    },{
                        fieldLabel: '结束日期',
                        xtype:'datefield',
                        id:'LOCUSDateTo',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCUSDateTo'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCUSDateTo')),
                        name: 'LOCUSDateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                            fieldLabel: '<font color=red></font>是否必填',
                            xtype : 'checkbox',
                            name : 'LOCUSRequired',
                            id:'LOCUSRequired',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOCUSRequired'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOCUSRequired')),
                            inputValue : true?'Y':'N',
                            checked:false
                    }]
                }]
            }]}
            
            ],
            
                    buttonAlign:'center',
                    buttons:[{
                                id:'btn_AddARCItemLocus',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddARCItemLocus'),
                                text:'添加',
                                iconCls : 'icon-add',
                                handler:function(){
                                    if(arcimrowid!=""){
                                        if (Ext.getCmp("LOCUSPoint").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"位点不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        if (Ext.getCmp("LOCUSARCIMDR").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"医嘱项目不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                        }
                                        
                                                             
                                        
                                        if (Ext.getCmp("LOCUSDateFrom").getValue()=="") {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能为空!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                            return;
                                        }
                                        
                                     
                                        if (Ext.getCmp("LOCUSDateFrom").getValue()!="" & Ext.getCmp("LOCUSDateTo").getValue()!="") {
                                            var fromdate=Ext.getCmp("LOCUSDateFrom").getValue().format("Ymd");
                                            var todate=Ext.getCmp("LOCUSDateTo").getValue().format("Ymd");
                                            if (fromdate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"开始日期不能大于结束日期!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        if ( Ext.getCmp("LOCUSDateTo").getValue()!="") {
                                            var todate=Ext.getCmp("LOCUSDateTo").getValue().format("Ymd");
                                            var toadydate=(new Date()).format("Ymd");
                                            if (toadydate > todate) {
                                             Ext.Msg.show({
                                                            title:'提示',
                                                            msg:"结束日期不能早于今天!",
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                             return;
                                            }
                                        }
                                        
                                        /// 1 LOCUSRowId ，2 ParRef  ，3 位点  4医嘱项目， 4 单位 ， 5是否必填  ，6 开始日期，7 结束日期
                                        var SaveDataStr=""+"^"+arcimrowid+"^"+Ext.getCmp("LOCUSPoint").getValue()+"^"+Ext.getCmp("LOCUSARCIMDR").getValue()+"^"+Ext.getCmp("LOCUSRequired").getValue()+"^"+Ext.getCmp("LOCUSDateFrom").getRawValue()+"^"+Ext.getCmp("LOCUSDateTo").getRawValue();
                                        Ext.Ajax.request({
                                                url:ARCItemLocus_Save_ACTION_URL,
                                                method:'POST',
                                                params:{
                                                    'SaveDataStr':SaveDataStr    
                                                },
                                                callback:function(options, success, response){
                                                    if(success){
                                                        var jsonData = Ext.util.JSON.decode(response.responseText);
                                                        if(jsonData.success == 'true'){
                                                            Ext.Msg.show({
                                                                            title:'提示',
                                                                            msg:'添加成功!',
                                                                            icon:Ext.Msg.INFO,
                                                                            buttons:Ext.Msg.OK,
                                                                            fn:function(btn){
                                                                                ARCItemLocusds.load({ 
                                                                                    params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid} 
                                                                                });  
                                                                                resetLOCUSPanel()
                                                                                
                                                                        }
                                                                });                         
                                                        }else{
                                                            Ext.Msg.show({
                                                                            title:'提示',
                                                                            msg:jsonData.errorinfo,
                                                                            icon:Ext.Msg.ERROR,
                                                                            buttons:Ext.Msg.OK
                                                                        });
                                                                    }
                                                }else{
                                                     Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"添加失败!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                    }
                                                }
                                        })
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                            },{
                                id:'btn_UpdateARCItemLocus',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateARCItemLocus'),
                                text:'修改',
                                iconCls : 'icon-update',
                                handler:function(){
                                    if(arcimrowid!=""){
                                             if(!ARCItemLocusList.selModel.hasSelection()){
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"请先选择一条数据!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return; 
                                             }      
                                             else{
                                                if (Ext.getCmp("LOCUSPoint").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"位点不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            if (Ext.getCmp("LOCUSARCIMDR").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"医嘱项目不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                            }
                                            
                                                                 
                                            
                                            if (Ext.getCmp("LOCUSDateFrom").getValue()=="") {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能为空!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                return;
                                            }
                                            
                                         
                                            if (Ext.getCmp("LOCUSDateFrom").getValue()!="" & Ext.getCmp("LOCUSDateTo").getValue()!="") {
                                                var fromdate=Ext.getCmp("LOCUSDateFrom").getValue().format("Ymd");
                                                var todate=Ext.getCmp("LOCUSDateTo").getValue().format("Ymd");
                                                if (fromdate > todate) {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"开始日期不能大于结束日期!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                                }
                                            }
                                            if ( Ext.getCmp("LOCUSDateTo").getValue()!="") {
                                                var todate=Ext.getCmp("LOCUSDateTo").getValue().format("Ymd");
                                                var toadydate=(new Date()).format("Ymd");
                                                if (toadydate > todate) {
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"结束日期不能早于今天!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return;
                                                }
                                            }
                                            var records=ARCItemLocusList.getSelectionModel().getSelections()
                                            /// 1 DEPRowId ，2 ParRef  ，3位点  4 医嘱项目 ， 5是否必填  ，6 开始日期，7 结束日期
                                            var SaveDataStr=records[0].get('LOCUSRowId')+"^"+arcimrowid+"^"+Ext.getCmp("LOCUSPoint").getValue()+"^"+Ext.getCmp("LOCUSARCIMDR").getValue()+"^"+Ext.getCmp("LOCUSRequired").getValue()+"^"+Ext.getCmp("LOCUSDateFrom").getRawValue()+"^"+Ext.getCmp("LOCUSDateTo").getRawValue();
                                            
                                            Ext.Ajax.request({
                                                    url:ARCItemLocus_Save_ACTION_URL,
                                                    method:'POST',
                                                    params:{
                                                        'SaveDataStr':SaveDataStr 
                                                    },
                                                    callback:function(options, success, response){
                                                        if(success){
                                                            var jsonData = Ext.util.JSON.decode(response.responseText);
                                                            if(jsonData.success == 'true'){
                                                            Ext.Msg.show({
                                                                        title:'提示',
                                                                        msg:'修改成功!',
                                                                        icon:Ext.Msg.INFO,
                                                                        buttons:Ext.Msg.OK,
                                                                        fn:function(btn){
                                                                            ARCItemLocusds.load({ 
                                                                               params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                                            });  
                                                                            resetLOCUSPanel()
                                                                        }
                                                                });                         
                                                        }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:jsonData.errorinfo,
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                           }else{
                                                                Ext.Msg.show({
                                                                                title:'提示',
                                                                                msg:"修改失败!",
                                                                                icon:Ext.Msg.ERROR,
                                                                                buttons:Ext.Msg.OK
                                                                            });
                                                                }
                                                         }
                                                })
                                            }
                                    }
                                    else{  
                                         Ext.Msg.show({
                                                title:'提示',
                                                msg:"请先选择一条医嘱项!",
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                         return;
                                    }
                                }
                            },{
                                id:'ARCItemLocus_del_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('ARCItemLocus_del_btn'),
                                text:'删除',
                                iconCls : 'icon-delete',
                                handler:function(){
                                    if (arcimrowid!=""){
                                            if(!ARCItemLocusList.selModel.hasSelection()){
                                                 Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"请先选择一条数据!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                            });
                                                 return; 
                                             }
                                             else{
                                                Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                                                 if(btn=='yes'){
                                                    var records=ARCItemLocusList.selModel.getSelections();
                                                    Ext.Ajax.request({
                                                                url:ARCItemLocus_DeleteData_ACTION_URL,
                                                                method:'POST',
                                                                params:{
                                                                    'id':records[0].get('LOCUSRowId')   
                                                                },
                                                                callback:function(options, success, response){
                                                                    if(success){
                                                                            ARCItemLocusds.load({ 
                                                                                params:{start : 0, limit : pagesize_pop, ParRef:arcimrowid}
                                                                            }); 
                                                                            resetLOCUSPanel()
                                                                    }else{
                                                                         Ext.Msg.show({
                                                                                        title:'提示',
                                                                                        msg:"关联医嘱项删除失败!",
                                                                                        icon:Ext.Msg.ERROR,
                                                                                        buttons:Ext.Msg.OK
                                                                                    });
                                                                        }
                                                                 }
                                                             });
                                                         }
                                                }); 
                                              }
                                        
                                    }
                                    else{
                                        Ext.Msg.show({
                                                        title:'提示',
                                                        msg:"请先选择一条医嘱项!",
                                                        icon:Ext.Msg.ERROR,
                                                        buttons:Ext.Msg.OK
                                                    });
                                         return;
                                    }
                                }
                                
                            },{
                                
                                id:'btn_RefreshARCItemLocus',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshARCItemLocus'),
                                text:'重置',
                                iconCls : 'icon-refresh',
                                handler:function(){
                                        Ext.getCmp("LOCUSARCIMDR").reset();
                                        Ext.getCmp("LOCUSPoint").reset();
                                        Ext.getCmp("LOCUSRequired").setValue(fales);
                                        Ext.getCmp("LOCUSDateFrom").setValue(TodayDate);
                                        Ext.getCmp("LOCUSDateTo").reset();
                                        
                                        var linenum=ARCItemLocusList.getSelectionModel().lastActive; 
                                        ARCItemLocusList.getSelectionModel().deselectRow(linenum)
                                }                 
                            }]
            
    }; 
    
    
    var ARCItemLocusPanel=new Ext.Panel({
        layout:'border',
        title:'位点',
        //frame:true,
        items:[ARCItemLocusformDetail,ARCItemLocusList]
    });
    
    ///ofy11 end
    */
    
    
    var fields=[
            'enable',
            'ARCIMRowId',
            'ARCIMCode',
            'ARCIMDesc',
            'orderprice',
            'ARCIMLinkInsu',
            'PHCDCode',
            'INCICode',
            'INFOSpec',
            'ARCIMBillGrpDesc',
            'ARCIMBillSubDRDesc',
            'OECOrderCatDRDesc',
            'ARCIMItemCatDRDesc',
            'ARCIMServMaterial',
            'ARCIMBillingUOMDRDesc',
            'ARCIMDefPriorityDRDesc',
            'ARCIMServiceGroupDRDesc',
            'ARCIMAbbrev',
            'ARCIMDerFeeRulesDRDesc',
            'ARCIMOrderOnItsOwn',
            'ARCIMAllowOrderWOStockCheck',
            'ARCIMSensitive',
            'ARCIMDefSensitive',
            'ARCIMEffDate',
            'ARCIMEffDateTo',
            'ARCIMOEMessage',
            'OECOrderCatDR',
            'ARCIMItemCatDR',
            'ARCIMDefPriorityDR',
            'ARCIMBillGrpRowId',
            'ARCIMBillSubDR',
            'ARCIMBillingUOMDR',
            'ARCIMServiceGroupDR',
            'ARCIMDerFeeRulesDR',
            'ARCIMChgOrderPerHour',
            'ARCIMDeceasedPatientsOnly',
            'ARCIMDisplayCumulative',
            'ARCIMAllowInputFreq',
            'ARCIMUseODBCforWord',
            'ARCIMRestrictEM',
            'ARCIMRestrictIP',
            'ARCIMRestrictOP',
            'ARCIMRestrictHP',
            //ofy6
            'ARCIMRestrictPML',
            'ARCIMSensitiveOrder',
            'ARCIMScanCodeBilling',
            'ARCIMText1',
            'ARCIMText2',
            'ARCIMText3',
            'ARCIMText4',
            'ARCIMText5',
            'ARCIMPatientOrderFile1',  ///20170824 恢复
            'ARCIMPatientOrderFile2',
            'ARCIMPatientOrderFile3',
            'ARCIMMaxCumDose',
            'ARCIMMaxQtyPerDay',
            'ARCIMMaxQty'
            //,
           // 'ARCIMDoublePrintFlag'
             
        ]
    
    var gridstore = new Ext.data.JsonStore({
        root:'data',
        totalProperty: 'total',
       // idProperty: 'rowid',
        successProperty : 'success',
        fields:fields ,
        proxy: new Ext.data.HttpProxy({
            url: GetList_ACTION_URL
        }),
        remoteSort : true
    });
    
    ///国家/地区标准编码
    Ext.BDP.AddReaderFieldFun(gridstore,fields,Ext.BDP.FunLib.TableName);
    
    var sm = new Ext.grid.CheckboxSelectionModel()
    //构建GridPanel数列
    
    
    var GridCM = [
            new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
            sm,
            {header: '医嘱ID',width:90,dataIndex: 'ARCIMRowId',align: 'left',sortable: true,hidden:true},
            {header: '可用',width: 40,dataIndex: 'enable',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '医嘱代码',width: 120,dataIndex: 'ARCIMCode',align: 'left',sortable: true},
            {header: '医嘱名称',id:'desc',width: 80,dataIndex: 'ARCIMDesc',align: 'left',sortable: true},
            {header: '账单单位',width: 80,dataIndex: 'ARCIMBillingUOMDRDesc',align: 'left',sortable: true},
            {header: '医保分类',width: 120,dataIndex: 'ARCIMLinkInsu',align: 'left',sortable: true,hidden:true},
            {header: '医嘱价格',width:90,dataIndex:'orderprice',align:'left',sortable:true},
            {header: '药物代码',width: 120,dataIndex: 'PHCDCode',align: 'left',sortable: true,hidden:true},
            {header: '库存代码',width: 120,dataIndex: 'INCICode',align: 'left',sortable: true,hidden:true},
            {header: '规格',width: 120,dataIndex: 'INFOSpec',align: 'left',sortable: true,hidden:true},
            {header: '账单组',width: 80,dataIndex: 'ARCIMBillGrpDesc',align: 'left',sortable: true},
            {header: '账单子组',width: 80,dataIndex: 'ARCIMBillSubDRDesc',align: 'left',sortable: true},
            {header: '医嘱大类',width: 100,dataIndex: 'OECOrderCatDRDesc',align: 'left',sortable: true},
            {header: '医嘱子类',width: 120,dataIndex: 'ARCIMItemCatDRDesc',align: 'left',sortable: true},
            {header: '医嘱优先级',width: 90,dataIndex: 'ARCIMDefPriorityDRDesc',align: 'left',sortable: true},
            {header: '独立医嘱',width: 80,dataIndex: 'ARCIMOrderOnItsOwn',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '无库存医嘱',width: 80,dataIndex: 'ARCIMAllowOrderWOStockCheck',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '加急医嘱',width: 80,dataIndex: 'ARCIMSensitive',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '默认加急',width: 80,dataIndex: 'ARCIMDefSensitive',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '服务/材料',width: 70,dataIndex: 'ARCIMServMaterial',align: 'left',sortable: true,
                    renderer : function(v){
                        if(v=='S'){ return '服务'; }
                        if(v=='M'){ return '材料'; }
                    }},
            {header: '服务组',width: 120,dataIndex: 'ARCIMServiceGroupDRDesc',align: 'left',sortable: true},
            {header: '缩写',width: 180,dataIndex: 'ARCIMAbbrev',align: 'left',sortable: true},    
            {header: '费用标准',width: 120,dataIndex: 'ARCIMDerFeeRulesDRDesc',align: 'left',sortable: true},
            {header: '医嘱备注',width: 180,dataIndex: 'ARCIMOEMessage',align: 'left',sortable: true},
            {header: '开始日期',width: 120,dataIndex: 'ARCIMEffDate',align: 'left',sortable: true},
            {header: '结束日期',width: 120,dataIndex: 'ARCIMEffDateTo',align: 'left',sortable: true},
            
            {header: 'Text1',width: 120,dataIndex: 'ARCIMText1',align: 'left',sortable: true},
            {header: 'Text2',width: 120,dataIndex: 'ARCIMText2',align: 'left',sortable: true},
            {header: 'Text3',width: 120,dataIndex: 'ARCIMText3',align: 'left',sortable: true},
            {header: 'Text4',width: 120,dataIndex: 'ARCIMText4',align: 'left',sortable: true},
            {header: 'Text5',width: 120,dataIndex: 'ARCIMText5',align: 'left',sortable: true},
            {header: 'Patient OrderFile1',width: 150,dataIndex: 'ARCIMPatientOrderFile1',align: 'left',sortable: true},
            {header: 'Patient OrderFile2',width: 150,dataIndex: 'ARCIMPatientOrderFile2',align: 'left',sortable: true},
            {header: 'Patient OrderFile3',width: 150,dataIndex: 'ARCIMPatientOrderFile3',align: 'left',sortable: true},
            
            {header: '单次最大剂量',width: 120,dataIndex: 'ARCIMMaxCumDose',align: 'left',sortable: true},
            {header: '每天最大剂量',width: 120,dataIndex: 'ARCIMMaxQtyPerDay',align: 'left',sortable: true},
            {header: '最大量',width: 120,dataIndex: 'ARCIMMaxQty',align: 'left',sortable: true},
            {header: '医嘱大类Dr',width: 60,dataIndex: 'OECOrderCatDR',align: 'left',sortable: true,hidden:true},                   
            {header: '医嘱子类Dr',width: 50,dataIndex: 'ARCIMItemCatDR',align: 'left',sortable: true,hidden:true},
            {header: '医嘱优先级Dr',width: 50,dataIndex: 'ARCIMDefPriorityDR',align: 'left',sortable: true,hidden:true},
            {header: '账单组Dr',width: 50,dataIndex: 'ARCIMBillGrpRowId',align: 'left',sortable: true,hidden:true},
            {header: '账单子组Dr',width: 50,dataIndex: 'ARCIMBillSubDR',align: 'left',sortable: true,hidden:true},
            {header: '账单单位Dr',width: 50,dataIndex: 'ARCIMBillingUOMDR',align: 'left',sortable: true,hidden:true},
            {header: '服务组Dr',width: 50,dataIndex: 'ARCIMServiceGroupDR',align: 'left',sortable: true,hidden:true},
            {header: '费用标准Dr',width: 50,dataIndex: 'ARCIMDerFeeRulesDR',align: 'left',sortable: true,hidden:true},
            {header: '小时医嘱',width: 120,dataIndex: 'ARCIMChgOrderPerHour',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '显示累计',width: 120,dataIndex: 'ARCIMDisplayCumulative',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '允许录入频次',width: 170,dataIndex: 'ARCIMAllowInputFreq',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '使用ODBC模板',width: 120,dataIndex: 'ARCIMUseODBCforWord',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '限制为急诊病人用',width: 120,dataIndex: 'ARCIMRestrictEM',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '限制为住院病人用',width: 120,dataIndex: 'ARCIMRestrictIP',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '限制为门诊病人用',width: 120,dataIndex: 'ARCIMRestrictOP',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '限制为体检病人用',width: 120,dataIndex: 'ARCIMRestrictHP',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '限制为已故病人用',width: 120,dataIndex: 'ARCIMDeceasedPatientsOnly',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            //ofy6
			{header: '是否扫码计费',width: 120,dataIndex: 'ARCIMScanCodeBilling',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon},
            {header: '敏感医嘱',width: 120,dataIndex: 'ARCIMSensitiveOrder',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon}
            //,
           // {header: '检验条码双份打印',width: 120,dataIndex: 'ARCIMDoublePrintFlag',align: 'left',sortable: true,renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon}
                
        ]


    /***********************************定义医嘱项与收费项目关联(以下)*******************************/

    var associatestore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : OrderLinkTar_ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [   {
                                    name : 'arcimdr',
                                    mapping : 'arcimdr',
                                    type : 'string'
                                }, {
                                    name : 'olttariffdr',    
                                    mapping : 'olttariffdr',
                                    type : 'string'
                                
                                }, {
                                    name : 'tarcode',
                                    mapping : 'tarcode',
                                    type : 'string'
                                }, {
                                    name:'tardesc',
                                    mapping:'tardesc',
                                    type:'string'
                                },{
                                    name:'tarnum',
                                    mapping:'tarnum',
                                    type:'string'
                                },{
                                    name:'taruom',
                                    mapping:'taruom',
                                    type:'string'
                                },{
                                    name : 'tarDate',
                                    mapping : 'tarDate',
                                    type : 'string'
                                }, {
                                    name : 'tarDateTo',
                                    mapping : 'tarDateTo',
                                    type : 'string'
                                }, {
                                    name : 'OLTBascPriceFlag',    ///基价模式标志 add@20170222  chenying 
                                    mapping : 'OLTBascPriceFlag',
                                    inputValue : true?'Y':'N'
                                }, {
                                    name : 'OLTBillOnceFlag',    ///多部位计价一次 add@20170304 chenying
                                    mapping : 'OLTBillOnceFlag',
                                    inputValue : true?'Y':'N'
                                    
                                } ,{
                                    name:'tarprice',
                                    mapping:'tarprice',
                                    type:'string'
                                },{
                                    name:'associaterowid',
                                    mapping:'associaterowid',
                                    type:'string'
                                }
                        ])  
            });
    associatestore.on('beforeload',function(){
            PriceCount="";
            associatestore.baseParams = { arcimrowid: arcimrowid ,hospid:hospComp.getValue()};
    });
    
    var updateassociatestore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : OrderLinkTar_ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [   {
                                    name : 'arcimdr',
                                    mapping : 'arcimdr',
                                    type : 'string'
                                }, {
                                    name : 'olttariffdr',    
                                    mapping : 'olttariffdr',
                                    type : 'string'
                                
                                }, {
                                    name : 'tarcode',
                                    mapping : 'tarcode',
                                    type : 'string'
                                }, {
                                    name:'tardesc',
                                    mapping:'tardesc',
                                    type:'string'
                                },{
                                    name:'tarnum',
                                    mapping:'tarnum',
                                    type:'string'
                                },{
                                    name:'taruom',
                                    mapping:'taruom',
                                    type:'string'
                                },{
                                    name : 'tarDate',
                                    mapping : 'tarDate',
                                    type : 'string'
                                }, {
                                    name : 'tarDateTo',
                                    mapping : 'tarDateTo',
                                    type : 'string'
                                }, {
                                    name : 'OLTBascPriceFlag',
                                    mapping : 'OLTBascPriceFlag',
                                    inputValue : true?'Y':'N'
                                }, {
                                    name : 'OLTBillOnceFlag',
                                    mapping : 'OLTBillOnceFlag',
                                    inputValue : true?'Y':'N'
                                    
                                } ,{
                                    name:'tarprice',
                                    mapping:'tarprice',
                                    type:'string'
                                },{
                                    name:'associaterowid',
                                    mapping:'associaterowid',
                                    type:'string'
                                }
                        ])  
            });
    updateassociatestore.on('beforeload',function(){
            PriceCount="";
            updateassociatestore.baseParams = { arcimrowid: arcimrowid ,hospid:hospComp.getValue()};
    });
    
    var copyassociatestore = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url : OrderLinkTar_ACTION_URL
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [   {
                                    name : 'arcimdr',
                                    mapping : 'arcimdr',
                                    type : 'string'
                                }, {
                                    name : 'olttariffdr',    
                                    mapping : 'olttariffdr',
                                    type : 'string'
                                
                                }, {
                                    name : 'tarcode',
                                    mapping : 'tarcode',
                                    type : 'string'
                                }, {
                                    name:'tardesc',
                                    mapping:'tardesc',
                                    type:'string'
                                },{
                                    name:'tarnum',
                                    mapping:'tarnum',
                                    type:'string'
                                },{
                                    name:'taruom',
                                    mapping:'taruom',
                                    type:'string'
                                },{
                                    name : 'tarDate',
                                    mapping : 'tarDate',
                                    type : 'string'
                                }, {
                                    name : 'tarDateTo',
                                    mapping : 'tarDateTo',
                                    type : 'string'
                                }, {
                                    name : 'OLTBascPriceFlag',
                                    mapping : 'OLTBascPriceFlag',
                                    inputValue : true?'Y':'N'
                                }, {
                                    name : 'OLTBillOnceFlag',
                                    mapping : 'OLTBillOnceFlag',
                                    inputValue : true?'Y':'N'
                                    
                                } ,{
                                    name:'tarprice',
                                    mapping:'tarprice',
                                    type:'string'
                                },{
                                    name:'associaterowid',
                                    mapping:'associaterowid',
                                    type:'string'
                                }
                        ])  
            });
    copyassociatestore.on('beforeload',function(){
            PriceCount="";
            copyassociatestore.baseParams = { arcimrowid: arcimrowid,hospid:hospComp.getValue() };
    });
     ///  定义 价格总计的标签
    var OrderPriceTb=new Ext.form.Label({
         xtype:'label',
         align:'center',
         text:'' 
    });
    var winOrderPriceTb=new Ext.form.Label({
         xtype:'label',
         align:'center',
         text:'' 
    }); 
    var copyOrderPriceTb=new Ext.form.Label({
         xtype:'label',
         align:'center',
         text:'' 
    }); 
    //  医嘱项与收费项目关联  列表
    var smTaritem  = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
    
    
    ///修改时
    var AssociateTaritem = new Ext.grid.GridPanel({
        id:'AssociateTaritem',
        region: 'center',
        autoHeight:true,
        closable:true,
        store: updateassociatestore,
        trackMouseOver: true,
        columns: [
                smTaritem,
                {header: '收费项目代码',width: 120,dataIndex: 'tarcode',align: 'center',sortable: true},
                {header: '收费项目名称',width: 200,dataIndex: 'tardesc',align: 'center',sortable: true},
                {header: '收费项目ID',width:120,dataIndex: 'olttariffdr',align: 'center',sortable: true,hidden:true},
                {header: '数量',width: 50,dataIndex: 'tarnum',align: 'center',sortable: true },
                {header: '单位',width: 70,dataIndex: 'taruom',align: 'center',sortable: true },
                {header: '开始日期',width: 80,dataIndex: 'tarDate',align: 'center',sortable: true},
                {header: '结束日期',width: 80,dataIndex: 'tarDateTo',align: 'center',sortable: true},
                
                
                {header: '基价模式',width: 80,dataIndex: 'OLTBascPriceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                
                {header: '多部位计价一次',width: 90,dataIndex: 'OLTBillOnceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                {header: '价格',width: 80,dataIndex: 'tarprice',align: 'center',sortable: true},
                {header: '关联rowid',width: 80,dataIndex: 'associaterowid',align: 'center',sortable: true,hidden:true}
            ],
        stripeRows: true,
        smTaritem: new Ext.grid.RowSelectionModel({
                singleSelect: true,
                listeners: {
                     rowselect: function(smTaritem, row, rec) {
                   }
                }
            }),
        viewConfig : {
                    forceFit : true
                },
        columnLines : true, 
        bbar:[OrderPriceTb],
        title: '医嘱项与收费项目关联明细'  
    });
    ///  获取价格总数
    getOrderprice=function(gridstore){
        comValue=0, PerPrice=0 ,totalPrice=0;
        var totalcount=gridstore.getCount();
        for(var i=0;i<totalcount;i++){
            PerPrice=gridstore.getAt(i).data.tarprice ;
            comValue=gridstore.getAt(i).data.tarnum ;
            enddateValue=gridstore.getAt(i).data.tarDateTo
                if(totalPrice==0){
                    totalPrice=PerPrice*comValue
                }
                else
                {
                    totalPrice=totalPrice+(PerPrice*comValue)
                }
         
        }
        if (totalPrice!=0){
            /// 四舍五入,保留2位小数点
            totalPrice=totalPrice.toFixed(3)
        }
        return totalPrice;
        
        
    }    
    
     AssociateTaritem.getStore().on('load', function() {
        totalPrice=0
        if (grid.selModel.hasSelection()) {
            var _record = grid.getSelectionModel().getSelected(); 
            totalPrice=_record.get('orderprice');  
            var price=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetOrderPrice",_record.get('ARCIMRowId'),hospComp.getValue());
            if (price!=""){
                OrderPriceTb.setText("收费项目合计金额为" +price+"元");
            }
            else{
                OrderPriceTb.setText("收费项目合计金额为0元");
            }
        }
        else
        {
            OrderPriceTb.setText("收费项目合计金额为0元");
        }
        
     });
         
    AssociateTaritem.on("rowclick", function(grid,rowIndex,e){  
        totalPrice=0 ;
        var record = AssociateTaritem.getSelectionModel().getSelected();
        OltRowid=record.data['associaterowid'];
        Ext.getCmp("tarcode").setValue(record.data['tarcode']);
        Ext.getCmp("tarname").setValue(record.data['tardesc']);
        Ext.getCmp("chargenum").setValue(record.data['tarnum']); 
        Ext.getCmp("OLTBascPriceFlag").setValue((record.data['OLTBascPriceFlag']=='Y')?true:false); 
        Ext.getCmp("OLTBillOnceFlag").setValue((record.data['OLTBillOnceFlag']=='Y')?true:false); 

        Ext.getCmp("EffDate").setValue(record.data['tarDate']);
        Ext.getCmp("EffDateTo").setValue(record.data['tarDateTo']);
        Ext.getCmp("tarcode").disable();
        Ext.getCmp("tarname").disable();
        ///Ext.getCmp("chargenum").disable();
        Ext.getCmp("EffDate").disable();
    }); 
    
    /////////////////////////医嘱添加时的  关联收费项表格 ////////////////////////////////////////////
    var winAssociateTaritem = new Ext.grid.GridPanel({
        id:'winAssociateTaritem',
        region: 'center',
        autoHeight:true,
        closable:true,
        store: associatestore,
        trackMouseOver: true,
        columns: [
                smTaritem,
                {header: '收费项目代码',width: 120,dataIndex: 'tarcode',align: 'center',sortable: true},
                {header: '收费项目名称',width: 200,dataIndex: 'tardesc',align: 'center',sortable: true},
                {header: '收费项目ID',width: 120,dataIndex: 'olttariffdr',align: 'center',sortable: true,hidden:true},
                {header: '数量',width: 50,dataIndex: 'tarnum',align: 'center',sortable: true },
                {header: '单位',width: 50,dataIndex: 'taruom',align: 'center',sortable: true },
                {header: '开始日期',width: 80,dataIndex: 'tarDate',align: 'center',sortable: true},
                {header: '结束日期',width: 80,dataIndex: 'tarDateTo',align: 'center',sortable: true},
                {header: '基价模式',width: 80,dataIndex: 'OLTBascPriceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                {header: '多部位计价一次',width: 90,dataIndex: 'OLTBillOnceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                
                    {header: '价格',width: 80,dataIndex: 'tarprice',align: 'center',sortable: true},
                {header: '关联rowid',width: 80,dataIndex: 'associaterowid',align: 'center',sortable: true,hidden:true}
            ],
        stripeRows: true,
        smTaritem: new Ext.grid.RowSelectionModel({
                singleSelect: true,
                listeners: {
                     rowselect: function(smTaritem, row, rec) {
                   }
                }
            }),
        viewConfig : {
                    forceFit : true
                },
        columnLines : true, 
        bbar:[winOrderPriceTb],
        title: '医嘱项与收费项目关联明细'  
    });
    winAssociateTaritem.on("rowclick", function(grid,rowIndex,e){  
        totalPrice=0;
        var record = winAssociateTaritem.getSelectionModel().getSelected();
        OltRowid=record.data['associaterowid'];
        Ext.getCmp("tarcode1").setValue(record.data['tarcode']);
        Ext.getCmp("tarname1").setValue(record.data['tardesc']);
        Ext.getCmp("chargenum1").setValue(record.data['tarnum']); 
        
        Ext.getCmp("OLTBascPriceFlag1").setValue((record.data['OLTBascPriceFlag']=='Y')?true:false); 
        Ext.getCmp("OLTBillOnceFlag1").setValue((record.data['OLTBillOnceFlag']=='Y')?true:false); 
        
        
        Ext.getCmp("EffDate1").setValue(record.data['tarDate']);
        Ext.getCmp("EffDateTo1").setValue(record.data['tarDateTo']);
        Ext.getCmp("tarcode1").disable();
        Ext.getCmp("tarname1").disable();
        Ext.getCmp("chargenum1").enable();
        Ext.getCmp("EffDate1").enable();
    }); 
    
    //////////////////////////医嘱复制窗口的 医嘱项关联收费项表格//////////////////////////////////////////////
    var copysmTaritem  = new Ext.grid.CheckboxSelectionModel({singleSelect: true, checkOnly: false, width: 20});
     var copyAssociateTaritem = new Ext.grid.GridPanel({
        id:'copyAssociateTaritem',
        region: 'center',
        autoHeight:true,
        closable:true,
        store: copyassociatestore,
        trackMouseOver: true,
        columns: [
                copysmTaritem,
                {header: '收费项目代码',width: 120,dataIndex: 'tarcode',align: 'center',sortable: true},
                {header: '收费项目名称',width: 200,dataIndex: 'tardesc',align: 'center',sortable: true},
                {header: '收费项目ID',width: 120,dataIndex: 'olttariffdr',align: 'center',sortable: true,hidden:true},
                {header: '数量',width: 50,dataIndex: 'tarnum',align: 'center',sortable: true },
                {header: '单位',width: 50,dataIndex: 'taruom',align: 'center',sortable: true },
                {header: '开始日期',width: 80,dataIndex: 'tarDate',align: 'center',sortable: true},
                {header: '结束日期',width: 80,dataIndex: 'tarDateTo',align: 'center',sortable: true},
                {header: '基价模式',width: 80,dataIndex: 'OLTBascPriceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                {header: '多部位计价一次',width: 90,dataIndex: 'OLTBillOnceFlag',align: 'center',sortable: true ,renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon},
                
                    {header: '价格',width: 80,dataIndex: 'tarprice',align: 'center',sortable: true},
                {header: '关联rowid',width: 80,dataIndex: 'associaterowid',align: 'center',sortable: true,hidden:true}
            ],
        stripeRows: true,
        copysmTaritem: new Ext.grid.RowSelectionModel({
                singleSelect: true,
                listeners: {
                     rowselect: function(copysmTaritem, row, rec) {
                   }
                }
            }),
        viewConfig : {
                    forceFit : true
                },
        columnLines : true, 
        bbar:[copyOrderPriceTb],
        title: '医嘱项与收费项目关联明细'  
    });
    
    copyAssociateTaritem.on("rowclick", function(grid,rowIndex,e){  
            totalPrice=0 ;
            var copyrecord = copyAssociateTaritem.getSelectionModel().getSelected();
            OltRowid=copyrecord.data['associaterowid'];
            Ext.getCmp("tarcode2").setValue(copyrecord.data['tarcode']);
            Ext.getCmp("tarname2").setValue(copyrecord.data['tardesc']);
            Ext.getCmp("chargenum2").setValue(copyrecord.data['tarnum']); 
            
            Ext.getCmp("OLTBillOnceFlag2").setValue((copyrecord.data['OLTBillOnceFlag']=='Y')?true:false); 
            Ext.getCmp("OLTBascPriceFlag2").setValue((copyrecord.data['OLTBascPriceFlag']=='Y')?true:false); 
            Ext.getCmp("EffDate2").setValue(copyrecord.data['tarDate']);
            Ext.getCmp("EffDateTo2").setValue(copyrecord.data['tarDateTo']);
            Ext.getCmp("tarcode2").disable();
            Ext.getCmp("tarname2").disable();
            Ext.getCmp("chargenum2").disable();
            
    }); 
 
    /***************************************定义医嘱项与收费项目关联(以上)***************************************/
    
    /**************************************弹窗 ,用于添加新医嘱项*********************************************************/
    var btnAdd = new Ext.Toolbar.Button({
            text: '添加',
            tooltip: '添加医嘱项',
            iconCls: 'icon-add',
            id:'btnadd',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnadd'),
            handler: btnAddHandler=function () {
                    tabs2.setActiveTab(0);      //激活医嘱项标签页
                    win.setTitle('添加新医嘱项');
                    win.setIconClass('icon-add');
                    //医嘱项标签页
                    winformDetail.getForm().reset();
                    //Referenceds.removeAll();
                    
                    //Ext.getCmp("txtAllergenType1").reset();
                    //Ext.getCmp("txtAllergen1").reset();
                    
                    
                    
                    ///ofy1深圳宝安中医院↓ 最后一条如果医嘱代码是数字，则默认医嘱代码加1， 如果医嘱代码是字符串则默认医嘱代码为空  ///isNaN  空或者数字返回false  字符串返回true
                    /*
                    var defcode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetLastARCItmMastCode");
                    if ((defcode!="")&&(isNaN(defcode)==false))  
                    {
                        Ext.getCmp('ordercode1').setValue(parseInt(defcode)+1);
                    }
                    */
                    ///↑
                    
                    
                    //关联零收费项标签页
                    //Ext.getCmp("zerofee1").setValue('0'); //清空是否零收费项checkbox
                    
                    //关联收费项
                    Ext.getCmp("DelOrderLinkTar_del_btn1").show();   //启用删除关联收费项按钮
                    
                    arcimrowid = "";
                    
                    associatestore.removeAll();     /// 移除医嘱项与收费项目关联数据
                    
                    winOrderHospStore.removeAll()
                    winOrderAliasStore.removeAll()
                    winOrderAgeSexds.removeAll()
                    //winOrderAllergyStore.removeAll()
                    winOrderExtCodeDS.removeAll()
                    winOrderRecLocDS.removeAll()
                    
                    win.show();
                    
                    ///禁用零收费项维护
                    //disableZeroChargeForAdd()
                    ///重置关联收费项界面
                    resetOrderLinkPanelForAdd()
                    
                    ///2016-1-12 陈莹
                    ///独立医嘱默认打勾
                    Ext.getCmp("independentorder1").setValue(true);
                    Ext.getCmp("EffDate1").setValue(TodayDate)
                    ///2016-5-10
                    Ext.getCmp("nostock1").setValue(true);
                    
                    ///医嘱项新增时开始日期默认当天
                    Ext.getCmp("fromdate1").setValue(TodayDate);
                    Ext.getCmp("OECOrderCatDR1").setValue("");
                    Ext.getCmp("arcitemcat1").setValue("");
                    var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                    if (flag==1)
                    {
                        var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR1").getValue()+"^"+Ext.getCmp("arcitemcat1").getValue()+"^0",hospComp.getValue());
                        Ext.getCmp("ordercode1").setValue(MaxCode) 
                    }
                            
                    /// 清空国家/地区标准编码数据 20160519
                    Ext.BDP.ResetFormFun(Ext.BDP.FunLib.TableName);
                        
                    
                    ///↓ofy2南方医院 医嘱优先级默认为 临时医嘱
                    /*var PRNOrderID=tkMakeServerCall("web.DHCBL.CT.OECPriority","GetPRNOrderID");
                    if (PRNOrderID!="") 
                    {
                        Ext.getCmp('defaultpriority1').setValue(parseInt(PRNOrderID));
                    }
                    */
                    ///↑
                    
                },
                    scope: this
             });
     
    //医嘱项删除按钮
    var btnDel = new Ext.Toolbar.Button({
             text: '删除',
             tooltip: '请选择一行后删除',
             iconCls: 'icon-delete',
             id:'del_btn',
             disabled :Ext.BDP.FunLib.Component.DisableFlag('del_btn'),    
             handler: function() {
                delFun();
             }
    });
    
    var GetItmByRowID_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetItmByRowID";

    var ReturnDataForUpdate2 = function(grid,url,rowid,hospid){
        Ext.Ajax.request({
        method : 'POST',
        url:url + "&ID=" + rowid+ "&hospid=" + hospid,
        success: function(response,options){
            var respText =Ext.util.JSON.decode(response.responseText); 
            ///var jsonData=Ext.util.JSON.decode(response.responseText)
            
            var nub = Ext.getCmp(grid).getSelectionModel().lastActive;   //获取选中行行号
            var obj = Ext.getCmp(grid).getSelectionModel().getSelections()[0].data;  //获取选择行列名对象组
            
            for (var code in obj){                                          // 遍历行列名对象组 
                if (code!="orderprice" )
                {
                    Ext.getCmp(grid).getStore().getAt(nub).set(code,eval("respText."+code));
                }
            }
            //var price=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetOrderPrice",arcimrowid,hospComp.getValue());                     
            //Ext.getCmp("grid").getStore().getAt(nub).set("orderprice",price);
            
        }
    });  
}
    //**********************************修改医嘱项功能函数******************************************//
    var SaveForUpdateARCIM = function(){
                
            //if (grid.selModel.hasSelection()) {
    		if (arcimrowid!="") {
                //var record = grid.getSelectionModel().getSelected(); 
                //arcimrowid=record.data['ARCIMRowId'];
                
                
                
                ArcItmMastStr="",ArcimCheckboxStr="",ZeroFeeStr=""
                
                if(formDetail.getForm().isValid()==false){
                         Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
                         return;
                    }
                    
                if (Ext.getCmp("todate").getValue()!="" & Ext.getCmp("fromdate").getValue()!="") {
                    var fromdate=Ext.getCmp("fromdate").getValue().format("Ymd");
                    var todate=Ext.getCmp("todate").getValue().format("Ymd");
                    if (fromdate > todate) {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'开始日期不能大于结束日期!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                        return;
                    }
                }
                
                /*if (Ext.getCmp("zerofee").getValue()=="1")   //是否 [零收费] 医嘱项?
                {
                    if (Ext.getCmp("chargesubcat").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'收费子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("emcsubcat").getValue()=="") {
                          Ext.Msg.show({
                                        title:'提示',
                                        msg:'核算子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("acctsubcat").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'会计子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("inpatsubcat").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'住院子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("outpatsubcat").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'门诊子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("mrsubcat").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'病案首页子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    ZeroFeeStr=Ext.getCmp("chargesubcat").getValue()+"^"+Ext.getCmp("emcsubcat").getValue()+"^"+Ext.getCmp("acctsubcat").getValue()+"^"+Ext.getCmp("inpatsubcat").getValue()+"^"+Ext.getCmp("outpatsubcat").getValue()+"^"+Ext.getCmp("mrsubcat").getValue()+"^"+Ext.getCmp("MCNew_com").getValue();
                }
                else
                {
                     ZeroFeeStr=""
                }
                */
                ///修改医嘱项时
                var priceflag=tkMakeServerCall("web.DHCBL.CT.DHCOrderLinkTar","GetPriceFlag",Ext.getCmp("arcitemcat").getValue(),arcimrowid,"");
                if (priceflag>0) {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:'医嘱子分类为Price类型的医嘱不能关联多条收费项，请核对数据!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                     return
                }
                
                
                ArcItmMastStr=Ext.getCmp("ordercode").getValue()+"^"+Ext.getCmp("orderdesc").getValue()+"^"+Ext.getCmp("orderabbrev").getValue()+"^"+Ext.getCmp("arcitemcat").getValue()+"^"+Ext.getCmp("billgroupother").getValue();  ///1-5
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("subbillgroupother").getValue()+"^"+Ext.getCmp("billunit").getValue()+"^"+Ext.getCmp("defaultpriority").getValue()+"^"+Ext.getCmp("fromdate").getRawValue()+"^"+Ext.getCmp("todate").getRawValue();   //6-10
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("orderadvice").getValue()+"^"+Ext.getCmp("form_servicegroup").getValue()+"^"+Ext.getCmp("material").getValue()+"^"+"^"+Ext.getCmp("ARCIMDerFeeRulesDR").getValue();   //11-15  14为空
                ArcItmMastStr= ArcItmMastStr+"^"+Ext.getCmp('ARCIMText1F').getValue()+"^"+Ext.getCmp('ARCIMText2F').getValue()+"^"+Ext.getCmp('ARCIMText3F').getValue()+"^"+ Ext.getCmp('ARCIMText4F').getValue()+"^"+ Ext.getCmp('ARCIMText5F').getValue();   //16-20
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMPatientOrderFile1").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile2").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile3").getValue()+"^"+Ext.getCmp("ARCIMMaxCumDose").getValue()+"^"+Ext.getCmp("ARCIMMaxQtyPerDay").getValue();   //21-25
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMMaxQty").getValue();   ///26
                
                ArcimCheckboxStr=Ext.getCmp('ARCIMChgOrderPerHourF').getValue()+"^"+Ext.getCmp('ARCIMDeceasedPatientsOnlyF').getValue()+"^"+Ext.getCmp('ARCIMDisplayCumulativeF').getValue()+"^"+ Ext.getCmp('ARCIMUseODBCforWordF').getValue()+"^"+Ext.getCmp('ARCIMRestrictEMF').getValue();   //1-5
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('ARCIMRestrictIPF').getValue()+"^"+ Ext.getCmp('ARCIMRestrictOPF').getValue()+"^"+Ext.getCmp('ARCIMRestrictHPF').getValue()+"^"+Ext.getCmp('ARCIMSensitiveOrderF').getValue()+"^"+Ext.getCmp("independentorder").getValue();   //6-10
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp("nostock").getValue()+"^"+Ext.getCmp("ARCIMSensitive").getValue()+"^"+Ext.getCmp("ARCIMDefSensitive").getValue()+"^"+Ext.getCmp("ARCIMAllowInputFreqF").getValue();  //14
                //ofy6
				ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('ARCIMScanCodeBillingF').getValue()  //15
                
                
                Ext.Ajax.request({
                    url:ARCIM_Update_ACTION_URL,
                    method:'POST',
                    params:{
                        'arcimrowid':arcimrowid,
                        'ArcItmMastStr':ArcItmMastStr,   //修改医嘱项数据串
                        'ZeroFeeStr':ZeroFeeStr ,        //关联零收费项目串
                        'ArcimCheckboxStr':ArcimCheckboxStr,
                        'LinkHospId':hospComp.getValue()
                    },
                    callback:function(options, success, response){
                        if(success){
                        
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                                var myrowid = jsonData.id;
                                
                                
                                //// 保存国家/地区标准编码 20160519
                                Ext.BDP.NationalCodeModFunUpdate(Ext.BDP.FunLib.TableName,myrowid)
                               
                                ReturnDataForUpdate2("grid",GetItmByRowID_ACTION_URL,myrowid,hospComp.getValue())
                                
                                win.hide();
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:'修改成功!',
                                                icon:Ext.Msg.INFO,
                                                buttons:Ext.Msg.OK,
                                                fn:function(btn){
                                                    var startIndex = grid.getBottomToolbar().cursor;
                                                    OrderAliasStore.load({
                                                            params:{start : 0, limit : pagesize_pop, ParRef:myrowid} 
                                                        });  
                                                    //grid.getStore().load({params:{ID:myrowid}});
                                                }
                                            });
                            }
                            else{
                                var errorMsg ='';
                                if(jsonData.info){
                                    errorMsg='<br />'+jsonData.info
                                }
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:errorMsg,
                                                minWidth:210,
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                     }
                              }
                         }
                });
            }
            else 
            {
                Ext.Msg.show({
                            title : '提示',
                            msg : '请先选择一条医嘱项!',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
            }
        };
     /*********************************************医嘱复制按钮****************************************/
             
    var btnSaveAs = new Ext.Toolbar.Button({
        text: '医嘱复制',
        tooltip: '通过修改已有医嘱项,快速建立新的医嘱项',
        iconCls: 'icon-add',
        id:'btnSaveAs',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveAs'), 
        handler: function btnSaveAsHandler() {
                
                var records =  grid.selModel.getSelections();
                var recordsLen= records.length;
                if(recordsLen == 0){
                        Ext.Msg.show({
                                        title:'提示',
                                        minWidth:280,
                                        msg:'请先选择一条医嘱项!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    }); 
                     return
                 };
                if(recordsLen > 1){
                        Ext.Msg.show({
                                        title:'提示',
                                        minWidth:280,
                                        msg:'每次只能选择一条医嘱!',
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                     }
                 else{
                            copytabs.setActiveTab(0);           //激活医嘱项标签页
                        
                            //医嘱项标签页
                            //Ext.getCmp("zerofee2").setValue('0'); //清空是否零收费项checkbox
                            Ext.getCmp("orderaliasinput2").setValue('');///别名置空 2016-2-26 chenying
                            
                            //关联收费项标签页
                            Ext.getCmp("DelOrderLinkTar_del_btn2").show();   //启用删除关联收费项按钮
                            Ext.getCmp("copytarck2").enable();                  //启用复制关联收费项checkbox
                            Ext.getCmp("copytarck2").setValue('0');         //清除复制关联收费项checkbox
                            
                            
                            copywin.show(); 
                            copywin.setTitle("医嘱复制");
                            copywin.setIconClass('icon-add');  
                            
                            copyassociatestore.removeAll();  //移除关联收费项gridstore数据
                            
                            
                            var record = grid.getSelectionModel().getSelected(); 
                        
                            //加载医嘱子类ComBox数据值
                            
                             ///医嘱大类
                            Ext.getCmp('OECOrderCatDR2').store.baseParams = {hospid:hospComp.getValue()};
                            Ext.getCmp("OECOrderCatDR2").store.load({
                                    params: {rowid:record.data['OECOrderCatDR']}, 
                                    callback: function(records, options, success){
                                        Ext.getCmp("OECOrderCatDR2").setValue(record.data['OECOrderCatDR']);
                                        Ext.getCmp("OECOrderCatDR2").setRawValue(record.data['OECOrderCatDRDesc']);
                                        ///医嘱子类
                                        Ext.getCmp("arcitemcat2").store.load({
                                                params: {rowid:record.data['ARCIMItemCatDR']}, 
                                                callback: function(records, options, success){
                                                    Ext.getCmp("arcitemcat2").setValue(record.data['ARCIMItemCatDR']);
                                                    Ext.getCmp("arcitemcat2").setRawValue(record.data['ARCIMItemCatDRDesc']);
                                                }
                                        });
                                    }
                            });
                            
                            //loadParams(grid,"OECOrderCatDR2","OECOrderCatDR","OECOrderCatDRDesc");
                             
                            //loadParams(grid,"arcitemcat2","ARCIMItemCatDR","ARCIMItemCatDRDesc");
                            //加载医嘱默认优先级ComBox数据值
                             loadParams(grid,"defaultpriority2","ARCIMDefPriorityDR","priority");
                        
                                
                             //服务组
                            Ext.getCmp('form_servicegroup2').store.baseParams = {hospid:hospComp.getValue()};
                            Ext.getCmp("form_servicegroup2").store.load({
                                    params: {rowid:record.data['ARCIMServiceGroupDR']}, 
                                    callback: function(records, options, success){
                                        Ext.getCmp("form_servicegroup2").setValue(record.data['ARCIMServiceGroupDR']);
                                        Ext.getCmp("form_servicegroup2").setRawValue(record.data['ARCIMServiceGroupDRDesc']);
                                    }
                            });
                            //加载服务组ComBox数据值
                            //loadParams(grid,"form_servicegroup","ARCIMServiceGroupDR","ARCIMServiceGroupDRDesc");
                            ///账单组
                            Ext.getCmp('billgroupother2').store.baseParams = {hospid:hospComp.getValue()};
                            Ext.getCmp("billgroupother2").store.load({
                                    params: {rowid:record.data['ARCIMBillGrpRowId']}, 
                                    callback: function(records, options, success){
                                        Ext.getCmp("billgroupother2").setValue(record.data['ARCIMBillGrpRowId']);
                                        Ext.getCmp("billgroupother2").setRawValue(record.data['ARCIMBillGrpDesc']);
                                        ///账单子组
                                        Ext.getCmp("subbillgroupother2").store.load({
                                                params: {rowid:record.data['ARCIMBillSubDR']}, 
                                                callback: function(records, options, success){
                                                    Ext.getCmp("subbillgroupother2").setValue(record.data['ARCIMBillSubDR']);
                                                    Ext.getCmp("subbillgroupother2").setRawValue(record.data['ARCIMBillSubDRDesc']);
                                                }
                                        });
                                    }
                            });     
                            
                            //加载服务组ComBox数据值
                             //loadParams(grid,"form_servicegroup2","ARCIMServiceGroupDR","ARCIMServiceGroupDRDesc");
                            
                            //加载账单组ComBox数据值        
                             //loadParams(grid,"billgroupother2","ARCIMBillGrpRowId","ARCIMBillGrpDesc");
                            
                             //加载账单子组ComBox数据值  
                            // loadParams(grid,"subbillgroupother2","ARCIMBillSubDR","ARCIMBillSubDRDesc");
                        
                             //加载费用标准ComBox数据值
                             loadParams(grid,"ARCIMDerFeeRulesDR2","ARCIMDerFeeRulesDR","ARCIMDerFeeRulesDRDesc");
                            
                             
                            //加载账单账单单位ComBox数据值
                             loadParams(grid,"billunit2","ARCIMBillingUOMDR","ARCIMBillingUOMDRDesc");
                              
                            arcimrowid=record.data['ARCIMRowId'];
                            Ext.getCmp("ordercode2").setValue(record.data['ARCIMCode']);   
                            ////自动生成代码 20170727
                            var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                            if (flag==1)
                            {
                                var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR2").getValue()+"^"+Ext.getCmp("arcitemcat2").getValue()+"^1",hospComp.getValue());
                                Ext.getCmp("ordercode2").setValue(MaxCode) 
                            }
                            Ext.getCmp("orderdesc2").setValue(record.data['ARCIMDesc']);
                            
                            Ext.getCmp("orderabbrev2").setValue(record.data['ARCIMAbbrev']);        
                            Ext.getCmp("fromdate2").setValue(TodayDate);   
                            Ext.getCmp("todate2").setValue("");
                            Ext.getCmp("orderadvice2").setValue(record.data['ARCIMOEMessage']);
                            Ext.getCmp("material2").setValue(record.data['ARCIMServMaterial']);
                                 
                            ///2016-08-08
                            Ext.getCmp("nostock2").setValue(true);
                            Ext.getCmp('independentorder2').setValue(record.get('ARCIMOrderOnItsOwn')=='Y'?true:false);
                            Ext.getCmp('ARCIMSensitive2').setValue(record.get('ARCIMSensitive')=='Y'?true:false);
                            Ext.getCmp('ARCIMDefSensitive2').setValue(record.get('ARCIMDefSensitive')=='Y'?true:false);
                            Ext.getCmp('ARCIMChgOrderPerHourCopy').setValue(record.get('ARCIMChgOrderPerHour')=='Y'?true:false);
                            Ext.getCmp('ARCIMDeceasedPatientsOnlyCopy').setValue(record.get('ARCIMDeceasedPatientsOnly')=='Y'?true:false);
                            Ext.getCmp('ARCIMDisplayCumulativeCopy').setValue((record.get('ARCIMDisplayCumulative'))=='Y'?true:false);
                            Ext.getCmp('ARCIMAllowInputFreqCopy').setValue((record.get('ARCIMAllowInputFreq'))=='Y'?true:false);
                            Ext.getCmp('ARCIMUseODBCforWordCopy').setValue((record.get('ARCIMUseODBCforWord'))=='Y'?true:false);
                            Ext.getCmp('ARCIMRestrictEMCopy').setValue((record.get('ARCIMRestrictEM'))=='Y'?true:false);
                            Ext.getCmp('ARCIMRestrictIPCopy').setValue((record.get('ARCIMRestrictIP'))=='Y'?true:false);            
                            Ext.getCmp('ARCIMRestrictOPCopy').setValue((record.get('ARCIMRestrictOP'))=='Y'?true:false);
                            Ext.getCmp('ARCIMRestrictHPCopy').setValue((record.get('ARCIMRestrictHP'))=='Y'?true:false);
                           
                            //ofy6 
				            Ext.getCmp('ARCIMScanCodeBillingCopy').setValue((record.get('ARCIMScanCodeBilling'))=='Y'?true:false);
                            Ext.getCmp('ARCIMSensitiveOrderCopy').setValue((record.get('ARCIMSensitiveOrder'))=='Y'?true:false); 
                            //Ext.getCmp('ARCIMDoublePrintFlagCopy').setValue((record.get('ARCIMDoublePrintFlag'))=='Y'?true:false);
                            Ext.getCmp('ARCIMScanCodeBillingCopy').setValue((record.get('ARCIMScanCodeBilling'))=='Y'?true:false); 
                            
                            Ext.getCmp("ARCIMText1Copy").setValue(record.data['ARCIMText1']);
                            Ext.getCmp("ARCIMText2Copy").setValue(record.data['ARCIMText2']);       
                            Ext.getCmp("ARCIMText3Copy").setValue(record.data['ARCIMText3']);    
                            Ext.getCmp("ARCIMText4Copy").setValue(record.data['ARCIMText4']);
                            Ext.getCmp("ARCIMText5Copy").setValue(record.data['ARCIMText5']);
                            Ext.getCmp("ARCIMPatientOrderFile12").setValue(record.data['ARCIMPatientOrderFile1']);  
                            Ext.getCmp("ARCIMPatientOrderFile22").setValue(record.data['ARCIMPatientOrderFile2']);  
                            Ext.getCmp("ARCIMPatientOrderFile32").setValue(record.data['ARCIMPatientOrderFile3']);  
                            Ext.getCmp("ARCIMMaxCumDose2").setValue(record.data['ARCIMMaxCumDose']);
                            Ext.getCmp("ARCIMMaxQtyPerDay2").setValue(record.data['ARCIMMaxQtyPerDay']);
                            Ext.getCmp("ARCIMMaxQty2").setValue(record.data['ARCIMMaxQty']);
                            ///禁用零收费项维护
                            //disableZeroChargeForCopy()
                            //重置关联收费项界面
                            resetOrderLinkPanelForCopy()
                    
                            //加载该医嘱项与收费项目的关联明细20120713
                            copyassociatestore.load({ 
                                params: {
                                            arcimrowid:arcimrowid,
                                            hospid:hospComp.getValue()
                                        }, 
                               callback: function(r, options, success){
                                            if(success){
                                                Ext.getCmp("copytarck2").setValue(true);
                                                copyOrderPriceTb.setText(''); 
                                            }
                                            else{
                                                 Ext.Msg.alert("提示",'医嘱与收费项目关联明细, 加载失败!');
                                                }
                                             }
                                    }); 
                     }
             }
    });
    
    //****************************************医嘱复制功能函数***********************************************//
    var SaveForCopyARCIM = function(){
                    //2022-09-13 医嘱子分类类型为药品类型的数据不允许在医嘱项界面添加
                    var arcictype=tkMakeServerCall("web.DHCBL.CT.ARCItemCat","GetTypeByARCICRowId",Ext.getCmp("arcitemcat2").getValue());
                    if ((arcictype=="R"))  //||(arcictype=="M")
                    {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'此界面不允许直接添加药品，请核对数据!',  ///材料  
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return;
                    }
                    arcimrowid="",ArcItmMastStr="", ZeroFeeStr="", ArcimCheckboxStr=""
                    
                    if(copyformDetail.getForm().isValid()==false){
                         Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
                         return;
                    }
                    
                /*if (Ext.getCmp("zerofee2").getValue()=="1") {   //是否 [零收费] 医嘱项?
                    if (Ext.getCmp("chargesubcat2").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'收费子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("emcsubcat2").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'核算子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("acctsubcat2").getValue()=="") {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'会计子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("inpatsubcat2").getValue()=="") {
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:'住院子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("outpatsubcat2").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'门诊子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                    if (Ext.getCmp("mrsubcat2").getValue()=="") {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'病案首页子分类不能为空!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                
                    ZeroFeeStr=Ext.getCmp("chargesubcat2").getValue()+"^"+Ext.getCmp("emcsubcat2").getValue()+"^"+Ext.getCmp("acctsubcat2").getValue()+"^"+Ext.getCmp("inpatsubcat2").getValue()+"^"+Ext.getCmp("outpatsubcat2").getValue()+"^"+Ext.getCmp("mrsubcat2").getValue()+"^"+Ext.getCmp("MCNew_com2").getValue();
                }
                else{
                     ZeroFeeStr=""
                }
                */
                //复制新增关联收费项目
                
                var NewLinkStr=""
                var tarcount = copyassociatestore.getCount();
                if(tarcount!=0){
                    AddOrdLinkTar="";
                    copyassociatestore.each(function(record){
                        
                        if(AddOrdLinkTar!="") AddOrdLinkTar = AddOrdLinkTar+"*";
                        
                        if (NewLinkStr!="")
                        {
                            NewLinkStr=NewLinkStr+"&"+record.get('tarDate')+"^"+record.data['tarDateTo']
                        }
                        else
                        {
                            NewLinkStr=record.get('tarDate')+"^"+record.data['tarDateTo']
                        }
                        
                        AddOrdLinkTar = AddOrdLinkTar+record.get('olttariffdr')+'^'+record.get('tarnum')+"^"+record.get('tarDate')+"^"+record.data['tarDateTo']+'^'+record.get('OLTBascPriceFlag')+'^'+record.get('OLTBillOnceFlag');      
                    }, this);
                }else{
                    AddOrdLinkTar="";
                }
                
                
                if (tarcount>1)
                {
                    var priceflag=tkMakeServerCall("web.DHCBL.CT.DHCOrderLinkTar","GetPriceFlag",Ext.getCmp("arcitemcat2").getValue(),"",NewLinkStr);
                    if (priceflag>0) {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'医嘱子分类为Price类型的医嘱不能关联多条收费项，请核对数据!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                }
                
                ArcItmMastStr=Ext.getCmp("ordercode2").getValue()+"^"+Ext.getCmp("orderdesc2").getValue()+"^"+Ext.getCmp("orderabbrev2").getValue()+"^"+Ext.getCmp("arcitemcat2").getValue()+"^"+Ext.getCmp("billgroupother2").getValue();   //1-5
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("subbillgroupother2").getValue()+"^"+Ext.getCmp("billunit2").getValue()+"^"+Ext.getCmp("defaultpriority2").getValue()+"^"+Ext.getCmp("fromdate2").getRawValue()+"^"+Ext.getCmp("todate2").getRawValue();  //6-10
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("orderadvice2").getValue()+"^"+Ext.getCmp("form_servicegroup2").getValue()+"^"+Ext.getCmp("material2").getValue()+"^"+Ext.getCmp("orderaliasinput2").getValue()+"^"+Ext.getCmp("ARCIMDerFeeRulesDR2").getValue();  //11-15
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp('ARCIMText1Copy').getValue()+"^"+Ext.getCmp('ARCIMText2Copy').getValue()+"^"+Ext.getCmp('ARCIMText3Copy').getValue()+"^"+Ext.getCmp('ARCIMText4Copy').getValue()+"^"+Ext.getCmp('ARCIMText5Copy').getValue();   ///16-20
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMPatientOrderFile12").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile22").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile32").getValue()+"^"+Ext.getCmp("ARCIMMaxCumDose2").getValue()+"^"+Ext.getCmp("ARCIMMaxQtyPerDay2").getValue();  //21-25
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMMaxQty2").getValue();  ///26
                ArcimCheckboxStr=Ext.getCmp('ARCIMChgOrderPerHourCopy').getValue()+"^"+Ext.getCmp('ARCIMDeceasedPatientsOnlyCopy').getValue()+"^"+Ext.getCmp('ARCIMDisplayCumulativeCopy').getValue()+"^"+ Ext.getCmp('ARCIMUseODBCforWordCopy').getValue()+"^"+Ext.getCmp('ARCIMRestrictEMCopy').getValue();
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('ARCIMRestrictIPCopy').getValue()+"^"+ Ext.getCmp('ARCIMRestrictOPCopy').getValue()+"^"+Ext.getCmp('ARCIMRestrictHPCopy').getValue()+"^"+Ext.getCmp('ARCIMSensitiveOrderCopy').getValue()+"^"+Ext.getCmp("independentorder2").getValue(); 
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp("nostock2").getValue()+"^"+Ext.getCmp("ARCIMSensitive2").getValue()+"^"+Ext.getCmp("ARCIMDefSensitive2").getValue()+"^"+Ext.getCmp("ARCIMAllowInputFreqCopy").getValue();
                
                //ofy6
			 	ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('ARCIMScanCodeBillingCopy').getValue()  //15
                
                
                Ext.Ajax.request({
                    url:ARCIM_Save_ACTION_URL,
                    method:'POST',
                    params:{
                        'arcimrowid':'',
                        'ArcItmMastStr':ArcItmMastStr,  //医嘱项新增数据串
                        'ZeroFeeStr':ZeroFeeStr,        //关联零收费项目串
                        'AddOrdLinkTar':AddOrdLinkTar,  //关联收费项数据串
                        'ArcimCheckboxStr':ArcimCheckboxStr,
                        'LinkHospId':hospComp.getValue()
                    },
                    callback:function(options, success, response){
                        if(success){
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                                copywin.hide();
                                var myrowid = jsonData.id;
                               Ext.Msg.show({
                                                title:'提示',
                                                msg:'快速添加医嘱项成功!',
                                                icon:Ext.Msg.INFO,
                                                buttons:Ext.Msg.OK,
                                                fn:function(btn){       
                                                    var startIndex = grid.getBottomToolbar().cursor;
                                                    grid.getStore().load({params:{ID:myrowid},
                                                        ///2016-2-23 chenying
                                                        callback: function(records, options, success){
                                                             if (success)
                                                             {
                                                                //Ext.getCmp('grid').fireEvent('rowclick',this); 
                                                                grid.getSelectionModel().selectRow(0,true)
                                                                selectMast()
                                                                
                                                             }
                                                    
                                                        }
                                                    
                                                    
                                                    });
                                                    
                                                    
                                                
                                                }
                                            });
                                }
                            else{
                                var errorMsg ='';
                                if(jsonData.info){
                                    errorMsg='<br />'+jsonData.info
                                }
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:errorMsg,
                                                minWidth:210,
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                     }
                             }
                        }
                    })
            };
    //********************************删除医嘱项操作******************************************//
    var delFun = function(){
        if(grid.selModel.hasSelection()){
            Ext.MessageBox.confirm('提示','确定要删除所选的数据吗?',function(btn){
                if(btn=='yes'){
                    var gsm = grid.getSelectionModel();// 获取选择列
                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                    Ext.Ajax.request({
                        url : DELETE_ACTION_URL,
                        method : 'POST',
                        params : {
                            'id' : rows[0].get('ARCIMRowId')
                        },
                        callback:function(options, success, response){
                            Ext.MessageBox.hide();
                            if(success){
                                var jsonData = Ext.util.JSON.decode(response.responseText);
                                if(jsonData.success == 'true'){
                                    Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
                                    
                                    
                                    /// 删除国家/地区标准编码数据 20160519
                                    Ext.BDP.DeleteFormFunUpdate(Ext.BDP.FunLib.TableName,rows[0].get('ARCIMRowId'));
                                        
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:'数据删除成功!',
                                                    icon:Ext.Msg.INFO,
                                                    buttons:Ext.Msg.OK,
                                                    fn:function(btn){
                                                            formDetail.getForm().reset();
                                                            comValue=0, PerPrice=0 ,totalPrice=0
                                                            /// 移除关联过敏原收费项的store
                                                            updateassociatestore.removeAll();
                                                            /// 移除 别名维护的store
                                                            OrderAliasStore.removeAll();
                                                            /// 移除接收科室的store
                                                            OrderRecLocDS.removeAll() 
                                                            /// 移除 外部代码的 store
                                                            OrderExtCode.removeAll() ;
                                                            /// 移除医院关联的store
                                                            OrderHospStore.removeAll();
                                                            /// 移除 年龄性别限制的store
                                                            OrderAgeSexds.removeAll();
                                                            ///　移除关联过敏原的store
                                                            //OrderAllergyStore.removeAll();
                                                            
                                                            ///ofy7 ARCLinkds.removeAll()
                                                            ///ofy9 
                                                            //ARCLinkReagentds.removeAll()
                                                            ///ofy10
                                                            ///ARCItemDependentds.removeAll()
                                                            ///ofy11
                                                            //ARCItemLocusds.removeAll()
                                                            
                                                                                         
                                                        }
                                            });
                                }
                                else{
                                    var errorMsg ='';
                                    if(jsonData.info){
                                        errorMsg='<br />错误信息:'+jsonData.info
                                    }
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:'数据删除失败!'+errorMsg,
                                                    minWidth:200,
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                }
                            }
                            else{
                                Ext.Msg.show({
                                                title:'提示',
                                                msg:'异步通讯失败,请检查网络连接!',
                                                icon:Ext.Msg.ERROR,
                                                buttons:Ext.Msg.OK
                                            });
                                    }
                            }
                        },this);
                    }
            },this);
        }
        else{
            Ext.Msg.show({
                            title:'提示',
                            msg:'请先选择一条医嘱项!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        });
                    }
            }
    
    var paging = new Ext.PagingToolbar({//分页工具
                pageSize : pagesize_main,
                store : gridstore,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                emptyMsg : "没有记录",
                plugins :[new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                    "change":function () {
                        pagesize_main=this.pageSize;
                    }
                }
        });
    /*  
    gridstore.on("load",function(){
        var linenum=grid.getSelectionModel().lastActive;  //取消选择行
        grid.getSelectionModel().deselectRow(linenum) 
    },this);
   */
    
    /// 刷新功能
    var RefreshFun=function (){
                arcimrowid="";
                Ext.BDP.FunLib.SelectRowId="";
                formDetail.getForm().reset();
                var linenum=grid.getSelectionModel().lastActive;  //取消选择行  取消选中行
                grid.getSelectionModel().deselectRow(linenum) 
                //P1代码,P2描述,P3药物查找,P4别名,P5账单组,P6账单子组,P7医嘱子类,P8服务组
                
                Ext.getCmp("code").reset(); //代码
                Ext.getCmp("desc").reset(); //描述    
                //Ext.getCmp("drugmastcode").reset(); //药物
                Ext.getCmp("alias").reset(); //别名        
                Ext.getCmp("billgroup").reset(); //账单组  
                Ext.getCmp("subbillgroup").reset();//账单子组   
                Ext.getCmp("ordercat").reset();//医嘱大类   
                Ext.getCmp("ordersubsort").reset();//医嘱子类   
                Ext.getCmp("servicegroup").reset(); //服务组   
                Ext.getCmp("limittype").setValue('');  // 限患者类型
            
                Ext.getCmp("ownflag").setValue("A");
                Ext.getCmp("ownflag").setRawValue("全部");
                Ext.getCmp("datefrom").setValue(""); 
                Ext.getCmp("enableflag").setValue("Y");
                Ext.getCmp("enableflag").setRawValue("可用");
                var p1 = Ext.getCmp("code").getValue(); //代码
                 var p2 = Ext.getCmp("desc").getValue(); //描述   
                 var p3 = "" //Ext.getCmp("drugmastcode").getValue(); //药物
                 var p4 = Ext.getCmp("alias").getValue(); //别名                       
                 var p5 = Ext.getCmp("billgroup").getValue(); //记账组 
                 var p6 = Ext.getCmp("subbillgroup").getValue(); //记账子组 
                 var p7 = Ext.getCmp("ordersubsort").getValue(); //医嘱子类                      
                 var p8 = Ext.getCmp("servicegroup").getValue(); //服务组  
                 var enableflag = Ext.getCmp("enableflag").getValue();
             
                 grid.getStore().baseParams={
                    hospid:hospComp.getValue(),
                    P1:p1,P2:p2,P3:p3,P4:p4,P5:p5,P6:p6,P7:p7,P8:p8,
                    enableflag:enableflag,
                    ownflag:Ext.getCmp("ownflag").getValue(),
                    ordercat:Ext.getCmp("ordercat").getValue(),
                    datefrom:Ext.getCmp("datefrom").getRawValue(),
                    limittype:Ext.getCmp("limittype").getValue()
                 };
                 gridstore.load({
                    params:{start:0, limit:pagesize_main},
                    callback: function(records, options, success){
                    }
                  }); 
                
                comValue=0, PerPrice=0 ,totalPrice=0
                /// 移除关联过敏原收费项的store
                updateassociatestore.removeAll();
                /// 移除 别名维护的store
                OrderAliasStore.removeAll();
                /// 移除接收科室的store
                OrderRecLocDS.removeAll() 
                /// 移除 外部代码的 store
                OrderExtCode.removeAll() ;
                /// 移除医院关联的store
                OrderHospStore.removeAll();
                /// 移除 年龄性别限制的store
                OrderAgeSexds.removeAll();
                ///　移除关联过敏原的store
                //OrderAllergyStore.removeAll();
                ///ofy7 ARCLinkds.removeAll()
                
                ///ofy9 
                //ARCLinkReagentds.removeAll()
                ///ofy10
                //ARCItemDependentds.removeAll()
                
                ///ofy11
                //ARCItemLocusds.removeAll()
                
                //清空 医嘱项目的价格
                OrderPriceTb.setText("");
                
                
                
      } 
    var resetForToolbarbtn=new Ext.Toolbar.Button({
        id:'resetForToolbarbtn',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('resetForToolbarbtn'),
        iconCls: 'icon-refresh',
        text:'重置',
        handler: RefreshFun
    });
//*********************创建 医嘱项Grid表格**********************************************************//
    
    
    /*
    ///开医嘱限制ofy8 吉大三院 开医嘱限制
    var CHILD_QUERY_ACTION_URL_res = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastRestrictLoc&pClassQuery=GetList";
    var CHILD_SAVE_ACTION_URL_res = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastRestrictLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItmMastRestrictLoc';
    var CHILD_OPEN_ACTION_URL_res = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastRestrictLoc&pClassMethod=OpenData";
    var CHILD_DELETE_ACTION_URL_res = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMastRestrictLoc&pClassMethod=DeleteData';
            
    //开医嘱限制删除按钮 
    var child_btnDel_res = new Ext.Toolbar.Button({
        text : '删除',
        tooltip : '请选择一行后删除',
        iconCls : 'icon-delete',
        id:'sub_del_btn_res',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn_res'),
        handler : function DelData_res() {
            if (child_grid_res.selModel.hasSelection()) {
                Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
                    if (btn == 'yes') {
                        Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
                        var gsm = child_grid_res.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        Ext.Ajax.request({
                            url : CHILD_DELETE_ACTION_URL_res,
                            method : 'POST',
                            params : {
                                'id' : rows[0].get('RESLRowId')
                            },
                            callback : function(options, success, response) {
                                if (success) {
                                    var jsonData = Ext.util.JSON.decode(response.responseText);
                                    if (jsonData.success == 'true') {
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '数据删除成功!',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                Ext.BDP.FunLib.DelForTruePage(child_grid_res,pagesize_pop);
                                                
                                            }
                                        });
                                    } else {
                                        var errorMsg = '';
                                        if (jsonData.info) {
                                            errorMsg = '<br/>错误信息:' + jsonData.info
                                        }
                                        Ext.Msg.show({
                                                    title : '提示',
                                                    msg : '数据删除失败!' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }
                                } else {
                                    Ext.Msg.show({
                                                title : '提示',
                                                msg : '异步通讯失败,请检查网络连接!',
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                }
                            }
                        }, this);
                    }
                }, this);
            } else {
                Ext.Msg.show({
                            title : '提示',
                            msg : '请选择需要删除的行!',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
            }
        }
    });
    
    
    
    
    //开医嘱限制添加\修改的Form 
    var child_WinForm_res = new Ext.form.FormPanel({
                id : 'child-form-save_res',
                labelAlign : 'right',
                labelWidth : 100,
                autoScroll:true,//滚动条
                frame : true,//baseCls : 'x-plain',
                reader: new Ext.data.JsonReader({root:'list'},
                                       
                                          [{name: 'RESLRowId',mapping:'RESLRowId',type:'string'},
                                         {name: 'RESLLocDR',mapping:'RESLLocDR',type:'string'},
                                         {name: 'RESLFunction',mapping:'RESLFunction',type:'string'},
                                         {name: 'RESLFlag',mapping:'RESLFlag',type:'string'},
                                         {name: 'RESLDateFrom',mapping:'RESLDateFrom',type:'string'},
                                         {name: 'RESLDateTo',mapping:'RESLDateTo',type:'string'}
                                   ]),
                defaults : {
                    anchor : '90%',
                    border : false
                },
                defaultType : 'textfield',
                items : [
                        {
                            fieldLabel : 'RESLParRef',
                            hideLabel : 'True',
                            hidden : true,
                            readOnly : true,
                            name : 'RESLParRef'
                        },{
                            fieldLabel : 'RESLRowId',
                            hideLabel : 'True',
                            hidden : true,
                            name : 'RESLRowId'
                        }, {
                            xtype : 'bdpcombo',
                            pageSize : Ext.BDP.FunLib.PageSize.Combo,
                            loadByIdParam : 'rowid',
                            listWidth:250,
                            fieldLabel : '<font color=red>*</font>科室',
                            name : 'RESLLocDR',
                            allowBlank : false,
                            id:'RESLLocDRF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLLocDRF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLLocDRF')),
                            hiddenName : 'RESLLocDR',
                            mode : 'remote',
                            store : new Ext.data.Store({
                                proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
                                reader : new Ext.data.JsonReader({
                                            totalProperty : 'total',
                                            root : 'data',
                                            successProperty : 'success'
                                        }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                            }),
                            queryParam : 'desc',
                            //triggerAction : 'all',  设置页码要注释此行
                            forceSelection : true,
                            selectOnFocus : false,
                            valueField : 'CTLOCRowID',
                            displayField : 'CTLOCDesc',
                            listeners:{
                                               'beforequery': function(e){
                                                    this.store.baseParams = {
                                                            desc:e.query,
                                                            hospid:hospComp.getValue()
                                                    };
                                                    this.store.load({params : {
                                                                start : 0,
                                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                                    }})
                                                
                                                }
                                        }
                        
                        }, {
                            xtype : 'combo',
                            fieldLabel : '<font color=red>*</font>开医嘱权限',
                            name : 'RESLFunction',
                            id:'RESLFunctionF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLFunctionF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLFunctionF')),
                            hiddenName : 'RESLFunction',
                            allowBlank : false,
                            mode : 'local',
                            store : new Ext.data.SimpleStore({
                                        fields : ['value', 'text'],
                                        data : [
                                                    ['R', '限制'],
                                                    ['A', '允许']
                                                ]
                                    }),
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            //typeAhead : true,
                            //minChars : 1,
                            valueField : 'value',
                            displayField : 'text'
                        
                        }, {
                            xtype : 'datefield',
                            fieldLabel : '开始日期',
                            name : 'RESLDateFrom',
                            id:'RESLDateFromF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLDateFromF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLDateFromF')),
                            format : BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                        
                        }, {
                            xtype : 'datefield',
                            fieldLabel : '结束日期',
                            name : 'RESLDateTo',
                            id:'RESLDateToF',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLDateToF'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLDateToF')),
                            format : BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                        
                    
                        }]
            });

            //开医嘱限制添加\修改窗口 
    var child_win_res = new Ext.Window({
        title : '',
        width : 350,
        height:300,
        layout : 'fit',
        //plain : true,// true则主体背景透明
        modal : true,
        frame : true,
        collapsible : true,
        //constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',
        items : child_WinForm_res,
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'sub_savebtn_res',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn_res'),
            handler : function() {
                
                if(child_WinForm_res.form.isValid()==false){
                    Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
                    return;
                }
                if (child_win_res.title == '添加') {
                    child_WinForm_res.form.submit({
                        clientValidation : true, // 进行客户端验证
                        waitMsg : '正在提交数据请稍后...',
                        waitTitle : '提示',
                        url : CHILD_SAVE_ACTION_URL_res,
                        method : 'POST',
                        success : function(form, action) {
                            if (action.result.success == 'true') {
                                child_win_res.hide();
                                var myrowid = action.result.id;
                                // var myrowid = jsonData.id;
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加成功!',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                child_grid_res.getStore().load({
                                                            params : {
                                                                start : 0,
                                                                limit : pagesize_pop
                                                            }
                                                        });
                                            }
                                });
                            } else {
                                var errorMsg = '';
                                if (action.result.errorinfo) {
                                    errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                }
                                Ext.Msg.show({
                                            title : '提示',
                                            msg : '添加失败!' + errorMsg,
                                            minWidth : 200,
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            }

                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
                        }
                    })
                } else {
                    Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
                        if (btn == 'yes') {
                            child_WinForm_res.form.submit({
                                clientValidation : true, // 进行客户端验证
                                waitMsg : '正在提交数据请稍后...',
                                waitTitle : '提示',
                                url : CHILD_SAVE_ACTION_URL_res,
                                method : 'POST',
                                success : function(form, action) {
                                    // alert(action);
                                    if (action.result.success == 'true') {
                                        child_win_res.hide();
                                        var myrowid = "rowid=" + action.result.id;
                                        // var myrowid = jsonData.id;
                                        Ext.Msg.show({
                                            title : '提示',
                                            msg : '修改成功!',
                                            icon : Ext.Msg.INFO,
                                            buttons : Ext.Msg.OK,
                                            fn : function(btn) {
                                                Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_res", CHILD_QUERY_ACTION_URL_res, myrowid)
                                                
                                            }
                                        });
                                    } else {
                                        var errorMsg = '';
                                        if (action.result.errorinfo) {
                                            errorMsg = '<br/>错误信息:' + action.result.errorinfo
                                        }
                                        Ext.Msg.show({
                                                    title : '提示',
                                                    msg : '修改失败!' + errorMsg,
                                                    minWidth : 200,
                                                    icon : Ext.Msg.ERROR,
                                                    buttons : Ext.Msg.OK
                                                });
                                    }
                                },
                                failure : function(form, action) {
                                    Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
                                }
                            })
                        }
                    }, this);
                    // WinForm.getForm().reset();
                }
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                child_win_res.hide();
            }
        }],
        listeners : {
            'show' : function() {
                //Ext.getCmp("child-form-save_res").getForm().findField("RESLLocDR").focus(true,800);
            },
            'hide' : function() {
            },
            'close' : function() {
            }
        }
    });
    
    ///开医嘱限制store
    var child_ds_res = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL_res }),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                                    name : 'RESLRowId',
                                    mapping : 'RESLRowId',
                                    type : 'string'
                                }, {
                                    name : 'RESLLocDesc',
                                    mapping : 'RESLLocDesc',
                                    type : 'string'
                                
                                }, {
                                    name : 'RESLFunction',
                                    mapping : 'RESLFunction',
                                    type : 'string'
                                }, {
                                    name : 'RESLFlag',
                                    mapping : 'RESLFlag',
                                    type : 'string'
                                
                                }, {
                                    name : 'RESLDateFrom',
                                    mapping : 'RESLDateFrom',
                                    type : 'string'
                                }, {
                                    name : 'RESLDateTo',
                                    mapping : 'RESLDateTo',
                                    type : 'string'
                                
                                }// 列的映射
                        ])
            });
    
    //开医嘱限制维护工具条 
    var child_tbbutton_res = new Ext.Toolbar({
        enableOverflow : true,
        items : [new Ext.Button({text:'添加',
                                tooltip : '添加一条数据',
                                iconCls : 'icon-add',
                                id:'sub_addbtn_res',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_res'),
                                handler : function AddData_res() {
                                    var gsm = grid.getSelectionModel();// 获取选择列
                                    var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                    child_win_res.setTitle('添加');
                                    child_win_res.setIconClass('icon-add');
                                    child_win_res.show('');
                                    child_WinForm_res.getForm().reset();
                                    child_WinForm_res.getForm().findField('RESLParRef').setValue(rows[0].get('ARCIMRowId'));
                                },
                                scope : this
                            }), '-',
                    new Ext.Button({text : '修改',
                                    tooltip : '请选择一行后修改',
                                    iconCls : 'icon-update',
                                    id:'sub_updatebtn_res',
                                    disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_res'),
                                    handler : function UpdateData_res() {
                                            if (!child_grid_res.selModel.hasSelection()) {
                                                Ext.Msg.show({
                                                        title : '提示',
                                                        msg : '请选择需要修改的行!',
                                                        icon : Ext.Msg.WARNING,
                                                        buttons : Ext.Msg.OK
                                                    });
                                            } else {
                                            var _record = child_grid_res.getSelectionModel().getSelected();
                                            child_win_res.setTitle('修改');
                                            child_win_res.setIconClass('icon-update');
                                            child_win_res.show('');
                                            Ext.getCmp("child-form-save_res").getForm().reset();
                                            Ext.getCmp("child-form-save_res").getForm().load({
                                                url : CHILD_OPEN_ACTION_URL_res + '&id=' + _record.get('RESLRowId'),
                                                waitMsg : '正在载入数据...',
                                                success : function(form,action) {
                                                    //Ext.Msg.alert(action);
                                                    //Ext.Msg.alert('编辑', '载入成功');
                                                },
                                                failure : function(form,action) {
                                                    Ext.Msg.alert('编辑', '载入失败');
                                                }
                                            });
                                        }
                                    },
                                    scope : this
                                }), '-', child_btnDel_res]
        });
    ///开医嘱限制child_grid_res 
    var child_grid_res = new Ext.grid.GridPanel({
                id : 'child_grid_res',
                region : 'center',
                closable : true,
                store : child_ds_res,
                trackMouseOver : true,
                columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
                        {
                            header : 'RESLRowId',
                            sortable : true,
                            dataIndex : 'RESLRowId',
                            hidden : true
                        }, {
                            header : '科室',
                            sortable : true,
                            dataIndex : 'RESLLocDesc',
                            renderer : Ext.BDP.FunLib.Component.GirdTipShow,
                            width : 160
                        
                        }, {
                            header : '开医嘱权限',
                            sortable : true,
                            dataIndex : 'RESLFunction',
                            renderer : function(v){
                                if(v=='R'){return '限制';}
                                if(v=='A'){return '允许';}
                                
                            
                            }
                        
                        }, {
                            header : '开始日期',
                            sortable : true,
                            dataIndex : 'RESLDateFrom'
                        
                        }, {
                            header : '结束日期',
                            sortable : true,
                            dataIndex : 'RESLDateTo'
                        
                        }],
                title : '开医嘱限制',
                //iconCls : 'icon-DP',
                //tools:Ext.BDP.FunLib.Component.HelpMsg,
                stripeRows : true,
                //stateful : true,
                viewConfig : {
                    forceFit : true
                },
                columnLines : true, //在列分隔处显示分隔符
                sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
                bbar : new Ext.PagingToolbar({
                        pageSize : pagesize_pop,
                        store : child_ds_res,
                        displayInfo : true,
                        displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                        emptyMsg : '没有记录',
                        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                        listeners : {
                            "change":function (t,p) {
                                pagesize_pop=this.pageSize;
                            }
                        }
                    }),
                tbar : new Ext.Toolbar({
                          items : ['科室',{
                                        xtype : 'bdpcombo',
                                        id : 'TextLOCDR',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('TextLOCDR'),
                                        mode : 'local',
                                        pageSize : Ext.BDP.FunLib.PageSize.Combo,
                                        listWidth : 250,
                                        store : new Ext.data.Store({
                                            proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
                                            reader : new Ext.data.JsonReader({
                                                        totalProperty : 'total',
                                                        root : 'data',
                                                        successProperty : 'success'
                                                    }, [ 'CTLOCRowID', 'CTLOCDesc' ])
                                        }),
                                        queryParam : 'desc',
                                        //triggerAction : 'all',
                                        forceSelection : true,
                                        selectOnFocus : false,
                                        valueField : 'CTLOCRowID',
                                        displayField : 'CTLOCDesc',
                                        listeners:{
                                               'beforequery': function(e){
                                                    this.store.baseParams = {
                                                            desc:e.query,
                                                            hospid:hospComp.getValue()
                                                    };
                                                    this.store.load({params : {
                                                                start : 0,
                                                                limit : Ext.BDP.FunLib.PageSize.Combo
                                                    }})
                                                
                                                }
                                        }
                                    }, '-',
                                    '开医嘱权限', {
                                        fieldLabel : '开医嘱权限',
                                        xtype : 'combo',
                                        id : 'TextFunc',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFunc'),
                                        width : 140,
                                        mode : 'local',
                                        triggerAction : 'all',// query
                                        forceSelection : true,
                                        selectOnFocus : false,
                                        minChars : 1,
                                        listWidth : 250,
                                        valueField : 'value',
                                        displayField : 'name',
                                        store : new Ext.data.JsonStore({
                                            fields : ['name', 'value'],
                                            data : [{
                                                name : '限制',
                                                value : 'R'
                                            }, {
                                                name : '允许',
                                                value : 'A'
                                            
                                            }]
                                        })},'-',
                                    new Ext.Button({iconCls : 'icon-search',
                                                    text : '搜索',
                                                    id:'sub_btnResearch_res',
                                                    disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch_res'),
                                                    handler : function() {
                                                                child_grid_res.getStore().baseParams={
                                                                    ParRef : grid.getSelectionModel().getSelections()[0].get('ARCIMRowId'),
                                                                    locdr:Ext.getCmp("TextLOCDR").getValue(),
                                                                    func:Ext.getCmp("TextFunc").getValue()
                                                                };
                                                                child_grid_res.getStore().load({params : {start : 0, limit : pagesize_pop}});
                                                            }
                                                    }), '-',
                                    new Ext.Button({ iconCls : 'icon-refresh',
                                                        text : '重置',
                                                        id:'sub_btnRefresh_res',
                                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh_res'),
                                                        handler : function() {
                                                            child_grid_res.getStore().baseParams={
                                                                ParRef : grid.getSelectionModel().getSelections()[0].get('ARCIMRowId')
                                                                
                                                            };
                                                            Ext.getCmp("TextLOCDR").reset();
                                                            Ext.getCmp("TextFunc").reset();
                                                            child_grid_res.getStore().load({ params : { start : 0, limit : pagesize_pop } });
                                                        }
                                                    })
                                    ],
                            listeners : {
                                    render : function() {
                                        child_tbbutton_res.render(child_grid_res.tbar) // tbar.render(panel.bbar)这个效果在底部
                                    }
                            }
                        })
            }); 
    //Ext.BDP.FunLib.ShowUserHabit(child_grid_res,"User.ARCItmMastRestrictLoc");
    //child_grid_res双击事件 
    child_grid_res.on('rowdblclick', function(child_grid_res) {
                if (!child_grid_res.selModel.hasSelection()) {
                    Ext.Msg.show({
                            title : '提示',
                            msg : '请选择需要修改的行!',
                            icon : Ext.Msg.WARNING,
                            buttons : Ext.Msg.OK
                        });
                } else {
                    var _record = child_grid_res.getSelectionModel().getSelected();
                    child_win_res.setTitle('修改');
                    child_win_res.setIconClass('icon-update');
                    child_win_res.show('');
                    Ext.getCmp("child-form-save_res").getForm().reset();
                    Ext.getCmp("child-form-save_res").getForm().load({
                        url : CHILD_OPEN_ACTION_URL_res + '&id=' + _record.get('RESLRowId'),
                        waitMsg : '正在载入数据...',
                        success : function(form,action) {
                            //Ext.Msg.alert(action);
                            //Ext.Msg.alert('编辑', '载入成功');
                        },
                        failure : function(form,action) {
                            Ext.Msg.alert('编辑', '载入失败');
                        }
                    });
                }
            });
    //开医嘱限制窗口   
    var child_list_win_res = new Ext.Window({
                    iconCls : 'icon-DP',
                    width : 760, //Ext.getBody().getWidth()*0.8,
                    height : 500,//Ext.getBody().getHeight()*.9,
                    layout : 'fit',
                    plain : true,// true则主体背景透明
                    modal : true,
                    //frame : true,
                    autoScroll : true,
                    collapsible : true,
                    hideCollapseTool : true,
                    //titleCollapse : true,
                    //bodyStyle : 'padding:3px',
                    constrain : true,
                    closeAction : 'hide',
                    items : [child_grid_res],
                    listeners : {
                        "show" : function(){
                                                    
                        },
                        "hide" : function(){
                            Ext.getCmp("TextLOCDR").reset();
                            Ext.getCmp("TextFunc").reset();
                        },
                        "close" : function(){
                        }
                    }
                });
    //开医嘱限制 
    var btnResLoc = new Ext.Toolbar.Button({
                text : '开医嘱限制',
                tooltip : '开医嘱限制',
                iconCls : 'icon-DP',
                id:'btnResLoc',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnResLoc'),
                handler : function() {
                    if (grid.selModel.hasSelection()) {
                        child_ds_res.baseParams={
                            ParRef : grid.getSelectionModel().getSelections()[0].get('ARCIMRowId')
                        };
                        child_ds_res.load({
                                params : {
                                        start : 0,
                                        limit : pagesize_pop
                                    }
                            });
                        var gsm = grid.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                        child_list_win_res.setTitle(rows[0].get('ARCIMDesc')+'---开医嘱限制');
                        child_list_win_res.show();
                    } else {
                        Ext.Msg.show({
                                    title : '提示',
                                    msg : '请选择一条医嘱数据!',
                                    icon : Ext.Msg.WARNING,
                                    buttons : Ext.Msg.OK
                                });
                    }
                }
            });
    
    ////开医嘱限制 完
    ///ofy8     
    
    */
        

    /*
    ///导出查询的数据 2017-1-16
    var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "

    ///2019-02-13
    function isIE()
    {
        ////navigator.userAgent.indexOf("compatible") > -1 && navigator.userAgent.indexOf("MSIE") > -1  //ie6,7,8,9,10
        //// navigator.userAgent.indexOf('Trident') > -1 &&  navigator.userAgent.indexOf("rv:11.0") > -1;  //ie11  //"ActiveXObject" in window
        if((!!window.ActiveXObject)||(navigator.userAgent.indexOf('Trident')>-1&&navigator.userAgent.indexOf("rv:11.0")>-1))
        {   return true;}
        else
        {  
            return false;
        }
    }
    
    ExportExcelData=function(ExportType) {
                var count=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetDataCount",ExportType);
                if (count==0){
                    Ext.Msg.show({
                        title : '提示',
                        msg : '没有查询到数据，请重新设置查询条件！' ,
                        minWidth : 200,
                        icon : Ext.Msg.INFO,
                        buttons : Ext.Msg.OK
                    }) 
                    return;
                }
                
                try{
                    var xlApp = new ActiveXObject("Excel.Application");
                    var xlBook = xlApp.Workbooks.Add();///默认三个sheet
                }catch(e){
                    var emsg="不能生成表格文件。"+ErrorMsgInfo;
                    Ext.Msg.show({
                        title : '提示',
                        msg : emsg ,
                        minWidth : 200,
                        icon : Ext.Msg.INFO,
                        buttons : Ext.Msg.OK
                    }) 
                    return;
                }     
                         
                xlBook.worksheets(1).select(); 
                var xlsheet = xlBook.ActiveSheet; 
                var titlenameStr=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetExceltitlename",ExportType);
                var titlenamearr=titlenameStr.split("&%");
                for (var m = 0; m < titlenamearr.length; m++) {                 
                    //第一行   
                    xlsheet.cells(1,m+1)=titlenamearr[m];
                    xlsheet.cells(1,m+1).Font.Bold = true;  //设置为粗体 
                    xlsheet.cells(1,m+1).WrapText=true;  //设置为自动换行*
                }
                    
                    
                   
                var row=0,taskcount=count;
                var ProgressText='';
                var winproBar = new Ext.Window({
                        closable:false,
                        modal:true,
                        width:314,
                        items:[
                            new Ext.ProgressBar({id:'proBar',text:'',width:300})
                        ] 
                });
                var proBar=new Ext.getCmp('proBar');
                Ext.TaskMgr.start({  
                  run:function(){
                    row++;
                    if(row>taskcount) //当到达最后一行退出
                    {
                        Ext.MessageBox.hide();
                        //alert(errorMsg)
                        //idTmr = window.setInterval("Cleanup();",1);
                        Ext.TaskMgr.stop(this);
                        winproBar.close();
                        
                        xlApp.Visible=true; 
                        xlBook.Close(savechanges=true);
                        CollectGarbage();
                        xlApp=null;
                        xlsheet=null;       
        
                        
                    }
                    else
                    {
                        var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetFieldValue",row,ExportType,hospComp.getValue());
                        var Detail2=DataDetailStr2.split("&%");     
                        for (var j=1;j<=Detail2.length;j++){
                            xlsheet.cells(1+row,j)="'"+Detail2[j-1];
                        }
                        progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";  
                        proBar.updateProgress(row/taskcount,progressText);
                      }
                         
                  },  
                  interval:100  
                });
                winproBar.show();
                     
                
    }
    */
    //调用js-xlsx 导出数据  2022-06-27
    function ExportExcelData(ExportType) {
        
        var xlsName="医嘱项目" 
        if (ExportType=='BDPORDERLINK') var xlsName="医嘱项目及关联收费项" 
        if (xlsName!="") 
        {  
            var taskcount=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetDataCount",ExportType);  //获取要导出的总条数  
            if (taskcount==0)
            {
                Ext.Msg.show({
                    title : '提示',
                    msg : '没有查询到数据，请重新确认！' ,
                    minWidth : 200,
                    icon : Ext.Msg.INFO,
                    buttons : Ext.Msg.OK
                })
                return;
            }
            if (taskcount>0)
            {
                //ext进度条，导出
                var winproBar = new Ext.Window({
                        closable:false,
                        modal:true,
                        width:314,
                        items:[
                            new Ext.ProgressBar({id:'proBar',text:'',width:300})
                        ] 
                });
                var proBar=Ext.getCmp('proBar');
                var TotalArray=[] //定义数组，用于给table赋值
                var titlenameStr=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetExceltitlename",ExportType);
                var titlenamearr=titlenameStr.split("&%");
                TotalArray.push(titlenamearr);    
                
                var row=0,taskcount=taskcount;
                var ProgressText='';
                Ext.TaskMgr.start({  
                  run:function(){
                    row++;
                    if(row>taskcount) //当到达最后一行退出
                    {
                        Ext.MessageBox.hide(); 
                        Ext.TaskMgr.stop(this);  
                        winproBar.close();
                        
                        var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
                        
                        //第一行增加样式
                        for (var key in sheet) {
                            if ((key=='A2')||(key=='!ref')){break;}
                            //非必填项模板颜色黑色
                            sheet[key]["s"] = {
                                font: {
                                    name: '宋体',
                                    sz: 14,
                                    bold: true,
                                    underline: false,
                                    color: {
                                        rgb: "000000"  //黑色
                                    }
                                },
                                alignment: {  //设置标题水平竖直方向居中，并自动换行展示
                                    horizontal: "center",
                                    vertical: "center",
                                    wrap_text: true
                                }
                            };
                        };
                        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
                    }
                    else
                    {
                        progressText = "正在导出第"+row+"条记录,总共"+taskcount+"条记录!";   
                        proBar.updateProgress(row/taskcount,progressText);
                        //将每条数据加到数组里
                        var DataDetailStr2=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetFieldValue",row,ExportType,hospComp.getValue());
                        var DetailArray=DataDetailStr2.split("&%");
                        TotalArray.push(DetailArray)
                      }
                  },  
                  interval:10
                }); 
                winproBar.show();
            }
            
        }  
    }
    
    ///导出查询数据
    var btnExport = new Ext.Button({
                id : 'btnExport',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExport'),
                iconCls : 'icon-export',
                text : '导出查询数据',
                handler :function() {
                        Ext.MessageBox.confirm('提示', '是否同时导出收费项信息?', function(btn) {
                            if (btn == 'yes') {
                                ExportExcelData("BDPORDERLINK")
                            }
                            else
                            {
                                ExportExcelData("BDPARCIM")
                            }
                            
                        }, this);
                        
                }
            });     
            
    var grid = new Ext.grid.GridPanel({
            id: 'grid',
            header: true,
            store: gridstore,
            columns: GridCM,
            trackMouseOver: true,
            stripeRows: true,
            //enableColumnResize: false,   
            autoScroll: true,
            autoExpandColumn: 'desc',   
            autoExpandMin: 230,
            sm : new Ext.grid.RowSelectionModel({singleSelect:true}),  
            region: 'center',
            viewConfig: {
                ///emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>未查询到数据或者未进行数据授权!</span>'",
                forceFit: false/*,
                //20190710  有结束日期的数据标记颜色区分
                getRowClass : function(record,rowIndex,rowParams,store){
                 if(record.data.ARCIMEffDateTo != '' ){
                          return 'x-grid-record-color';
                    }
                 }*/
            },
            columnLines : true, 
            tbar: {
                items:[btnAdd, '-', btnDel, '-', btnSaveAs,'-',btnEff,'-',btnConfig,'-',btnLocAut,'-',
                Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', 
                resetForToolbarbtn,'-',
                ///btnResLoc,'-',   ///ofy8吉大三院
                btnExport,'-',
                btnSort,'-',btnTrans
                ,'->',btnlog,'-',btnhislog
                ,helphtmlbtn]                 
            },
            bbar: paging,
            stateId : 'grid'
    });
    
    ///国家/地区标准编码 20160519
    Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);

    Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
    
    /*************************** 医嘱项搜索功能  *********************************************************/
    var search=function (){
                     var p1 = Ext.getCmp("code").getValue(); //代码
                     var p2 = Ext.getCmp("desc").getValue(); //描述   
                     var p3 = "" //Ext.getCmp("drugmastcode").getValue(); //药物
                     var p4 = Ext.getCmp("alias").getValue(); //别名                       
                     var p5 = Ext.getCmp("billgroup").getValue(); //账单组 
                     var p6 = Ext.getCmp("subbillgroup").getValue(); //账单子组 
                     var p7 = Ext.getCmp("ordersubsort").getValue(); //医嘱子类                      
                     var p8 = Ext.getCmp("servicegroup").getValue(); //服务组  
                     var enableflag = Ext.getCmp("enableflag").getValue();
                     var linenum=grid.getSelectionModel().lastActive;  //取消选择行  取消选中行
                     grid.getSelectionModel().deselectRow(linenum) 
                     grid.getStore().baseParams={
                        hospid:hospComp.getValue(),
                        P1:p1,P2:p2,P3:p3,P4:p4,P5:p5,P6:p6,P7:p7,P8:p8,
                        enableflag:enableflag,
                        ownflag:Ext.getCmp("ownflag").getValue(),
                        ordercat:Ext.getCmp("ordercat").getValue(),
                        datefrom:Ext.getCmp("datefrom").getRawValue(),
                        limittype:Ext.getCmp("limittype").getValue()
                     };
                     gridstore.load({
                        params:{start:0, limit:pagesize_main},
                        callback: function(records, options, success){
                      }
                  }); 
                   
                    //formDetail.getForm().reset();
                    comValue=0, PerPrice=0 ,totalPrice=0
                    /// 移除关联过敏原收费项的store
                    updateassociatestore.removeAll();
                    /// 移除 别名维护的store
                    OrderAliasStore.removeAll();
                    /// 移除接收科室的store
                    OrderRecLocDS.removeAll() 
                    /// 移除 外部代码的 store
                    OrderExtCode.removeAll() ;
                    /// 移除医院关联的store
                    OrderHospStore.removeAll();
                    /// 移除 年龄性别限制的store
                    OrderAgeSexds.removeAll();
                    ///　移除关联过敏原的store
                    //OrderAllergyStore.removeAll();
                    ///ofy7 ARCLinkds.removeAll()
                    
                    ///ofy9 
                    //ARCLinkReagentds.removeAll()
                    ///ofy10
                    //ARCItemDependentds.removeAll()
                    ///ofy11
                    //ARCItemLocusds.removeAll()
                    
                    //修改查询条件查询时，清空医嘱项详情
                    arcimrowid="";
                    Ext.BDP.FunLib.SelectRowId="";
                    formDetail.getForm().reset();
                    //清空 医嘱项目的价格
                    OrderPriceTb.setText("");
           }  
           

///*******************************左侧的搜索框*****************************************************///
    
      var limittypeStore=new Ext.data.JsonStore({
        url:LIMITTYPE_ACTION_URL,
        root: 'data',
        totalProperty: 'total',
        idProperty: 'rowid',
        fields:['LimitCode','LimitDesc']
    });         
    var TextLimittype = new Ext.form.MultiSelect({ 
        fieldLabel: '限患者类型',     
        id:'limittype',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('limittype'),
        forceSelection: true,
        triggerAction : 'all',
        selectOnFocus:false,
        mode:'local',
        queryParam : 'desc',
        pageSize:ComboPage,
        minChars: 0,  
        listWidth:250,
        valueField:'LimitCode',
        displayField:'LimitDesc',
        store:limittypeStore, 
        listeners:{
            'select': function(field,e){ 
                    search();
            },
            'beforequery': function(e){
                    this.store.baseParams = {
                        desc:e.query 
                    };
                    this.store.load({params : {
                        start : 0,
                        limit : ComboPage
                    }}) 
             }
        }       
    });   
    limittypeStore.load();
      
    var formSearch = new Ext.form.FormPanel({
        frame:true,
        border:false,
        width:240,
        split: true,
        labelWidth: 100,
        labelAlign : 'right',
        layout:'form',
        defaults : {
                    anchor : '95%'
                },
        items:[hospComp,  //多院区医院
            {  
                xtype : "textfield",
                fieldLabel:'医嘱代码',
                id:'code',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('code'),
                listeners :{
                specialkey: function(field, e){ 
                    ///回车查询
                    if (e.getKey() == e.ENTER) {
                        
                        search();
                    }
                }
                }
          }, {  
                xtype : "textfield",
                fieldLabel:'医嘱名称',
                id:'desc',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('desc')
            },  {  
                xtype : "textfield",
                fieldLabel:'医嘱别名',
                id:'alias',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('alias')
                  
            }, {
                fieldLabel:'账单组',
                id:'billgroup',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('billgroup'),
                xtype:'combo',
                triggerAction : 'all',
                allQuery:'',   
                forceSelection: true,
                selectOnFocus:false,
                mode:'remote',
                queryParam:'desc',
                pageSize:ComboPage,
                minChars: 0,
                listWidth:250,
                valueField:'ARCBGRowId',
                displayField:'ARCBGDesc',
                store:new Ext.data.JsonStore({
                   url:BillGroup_ACTION_URL,
                   root: 'data',
                   totalProperty: 'total',
                   idProperty: 'rowid',
                   fields:['ARCBGRowId','ARCBGDesc']
                }),
                 listeners:{
                       'select': function(field,e){
                            Ext.getCmp("subbillgroup").setValue("")
                            search();
                        },
                        'beforequery': function(e){
                            this.store.baseParams = {
                                desc:e.query,
                                hospid:hospComp.getValue()
                            };
                            this.store.load({params : {
                                        start : 0,
                                        limit : ComboPage
                            }})
                    
                        }
                 }
       }, {
                fieldLabel:'账单子组',
                id:'subbillgroup',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('subbillgroup'),
                xtype:'combo',
                triggerAction : 'all',
                forceSelection: true,
                selectOnFocus:true,
                mode:'remote',
                queryParam:'desc',
                pageSize:ComboPage,
                minChars: 0,
                listWidth:250,
                valueField:'ARCSGRowId',
                displayField:'ARCSGDesc',
                store: new Ext.data.JsonStore({
                      url:BillSubGroup_ACTION_URL,
                      root: 'data',
                      totalProperty: 'total',
                      idProperty: 'rowid',
                      fields:['ARCSGRowId','ARCSGDesc']
                }),
                listeners:{
                     'select': function(field,e){
                          search();
                     },
                     'beforequery': function(e){
                            this.store.baseParams = {
                                desc:e.query,
                                hospid:hospComp.getValue(),
                                ParRef:Ext.getCmp("billgroup").getValue()
                            };
                            this.store.load({params : {
                                        start : 0,
                                        limit : ComboPage
                            }})
                    
                     }
                 }
        /* },  {  
                id:'drugmastcode',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('drugmastcode'),
                fieldLabel:'药物查找',
                xtype:'trigger',
                autoCreate:{tag:'input',type:'text',size:'16',autocomplete:'off'},
                hideTrigger:false,
                triggerClass:'elp-trigger',//x-form-trigger,x-form-clear-trigger,x-form-date-trigger,x-form-search-trigger,custom-trigger
                onTriggerClick:function(e){
                    storeDrug.load({ params: { start: 0, limit: pagingToolbarDrug.pageSize} });
                    if(!winDrug){
                        winDrug = new Ext.Window({
                            title:'药物查找(<span style=\'color:red\'>双击选择</span>)',
                            iconCls:'icon-find',
                            width:680,
                            height:450,
                            layout:'fit',
                            minWidth:650,
                            minHeight:450,
                            modal:true,
                            buttonAlign:'center',
                            closeAction:'hide',   
                            items: gridDrug,
                            buttons:[{
                                text:'确定',
                                id:'ok_btn',
                                disabled : Ext.BDP.FunLib.Component.DisableFlag('ok_btn'),
                                handler:function(){
                                    var record=gridDrug.getSelectionModel().getSelected();
                                    Ext.getCmp("drugmastcode").setValue(record.get('PHCDCode'));
                                    winDrug.hide();
                                }
                            },{
                                text:'关闭',
                                iconCls : 'icon-close',
                                handler:function(){
                                    winDrug.hide();
                                }
                            }],
                            listeners : {
                                "show" : function() {},
                                "hide" : function() {
                                    resetGridDrug();
                                },
                                "close" : function() {}
                            }
                        });
                    }
                    winDrug.show(this);
                }*/
         },{
                        fieldLabel: '医嘱大类',
                        xtype:'combo',
                        id:'ordercat',
                        disabled : Ext.BDP.FunLib.Component.DisableFlag('ordercat'),
                        forceSelection: true,
                        triggerAction : 'all',
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ORCATRowId',
                        displayField:'ORCATDesc',
                        store:new Ext.data.JsonStore({
                            url:OrderCatDR_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ORCATRowId','ORCATDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("ordersubsort").setValue("");
                                    search();
                            },
                            'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                        }
            }, {
                fieldLabel:'医嘱子类',
                xtype:'combo',
                triggerAction : 'all',
                id:'ordersubsort',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('ordersubsort'),
                forceSelection: true,
                selectOnFocus:true,
                mode:'remote',
                queryParam : 'desc',
                pageSize:ComboPage,
                minChars: 0,
                listWidth:250,
                valueField:'ARCICRowId',
                displayField:'ARCICDesc',
                store: arcimcatds=new Ext.data.JsonStore({
                    url:ItemCat_ACTION_URL,
                    root: 'data',
                    totalProperty: 'total',
                    idProperty: 'rowid',
                    fields:['ARCICRowId','ARCICCode','ARCICDesc']
                }),
                listeners:{
                     'select': function(field,e){
                          search();
                     },
                     'beforequery': function(e){
                            this.store.baseParams = {
                                desc:e.query,
                                hospid:hospComp.getValue(),
                                ordcat:Ext.getCmp("ordercat").getValue()
                            };
                            this.store.load({params : {
                                        start : 0,
                                        limit : ComboPage
                            }})
                    
                     }
                 }      
         }, {
                fieldLabel:'服务组',
                id:'servicegroup',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('servicegroup'),
                xtype:'combo',
                triggerAction : 'all',
                forceSelection: true,
                selectOnFocus:true,
                mode:'remote',
                queryParam:'desc',
                pageSize:ComboPage,
                minChars: 0,
                listWidth:250,
                valueField:'SGRowId',
                displayField:'SGDesc',
                store:new Ext.data.JsonStore({
                    url:resourcegroup_ACTION_URL,
                    root: 'data',
                    totalProperty: 'total',
                    idProperty: 'rowid',
                    fields:['SGRowId','SGCode','SGDesc']
                }),
                listeners:{
                     'select': function(field,e){
                          search();
                     },
                    'beforequery': function(e){
                            this.store.baseParams = {
                                desc:e.query,
                                hospid:hospComp.getValue()
                            };
                            this.store.load({params : {
                                        start : 0,
                                        limit : ComboPage
                            }})
                    
                     }
                    }   
            }, {
                fieldLabel:'是否可用',
                id:'enableflag',
                editable:false,
                disabled : Ext.BDP.FunLib.Component.DisableFlag('enableflag'),
                xtype:'combo',
                triggerAction : 'all',
                forceSelection: true,
                selectOnFocus:true,
                mode:'local',
                queryParam:'desc',
                pageSize:ComboPage,
                //minChars: 0,
                listWidth:250,
                valueField:'value',
                displayField:'name',
                store : new Ext.data.JsonStore({
                        fields : ['name', 'value'],
                        data : [{
                                    name : '全部',
                                    value : 'A'
                                }, {
                                    name : '可用',
                                    value : 'Y'
                                }, {
                                    name : '不可用',
                                    value : 'N'
                                }]
                    }),
                listeners:{
                     'select': function(field,e){
                          search();
                     }
                }
                
              }, {
                fieldLabel:'独立医嘱',
                id:'ownflag',
                editable:false,
                disabled : Ext.BDP.FunLib.Component.DisableFlag('ownflag'),
                xtype:'combo',
                triggerAction : 'all',
                forceSelection: true,
                selectOnFocus:true,
                mode:'local',
                queryParam:'desc',
                pageSize:ComboPage,
                //minChars: 0,
                listWidth:250,
                valueField:'value',
                displayField:'name',
                store : new Ext.data.JsonStore({
                        fields : ['name', 'value'],
                        data : [{
                                    name : '全部',
                                    value : 'A'
                                }, {
                                    name : '独立医嘱',
                                    value : 'Y'
                                }, {
                                    name : '非独立医嘱',
                                    value : 'N'
                                }]
                    }),
                listeners:{
                     'select': function(field,e){
                          search();
                     }
                }
                
                
            },{
                fieldLabel: '医嘱项开始日期',
                xtype:'datefield',
                id:'datefrom',
                readOnly : Ext.BDP.FunLib.Component.DisableFlag('datefrom'),
                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('datefrom')),
                name: 'datefrom',
                format: BDPDateFormat,
                enableKeyEvents : true,
                listeners : { 
                    'keyup' : function(field, e){ 
                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                    }
                }       
            },TextLimittype
            ],
        buttonAlign:"center",
        buttons: [
        {
            text: '搜索',
            width: 5,
            iconCls: 'icon-search',
            id:'sdsearchbtn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('sdsearchbtn'),
            handler: search
        },{
            text: '重置',
            width: 5,
            iconCls: 'icon-refresh',
            id:'cleancheck',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('cleancheck'),
            handler:RefreshFun
        }]
    });
   Ext.getCmp("enableflag").setValue("Y");
   Ext.getCmp("enableflag").setRawValue("可用");
   Ext.getCmp("ownflag").setValue("A");
   Ext.getCmp("ownflag").setRawValue("全部"); 
    var winDrug;
    var storeDrug = new Ext.data.JsonStore({
        url:GetDrugList_ACTION_URL,
        root: 'data',
        totalProperty: 'total',
        idProperty: 'PHCDRowId',
        fields:['PHCDRowId','PHCDCode','PHCDName']
    });
    var pagingToolbarDrug = new Ext.PagingToolbar({
        pageSize: 20,
        store: storeDrug,
        displayInfo: true,
        plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
        listeners : {
            "change":function (t,p) {
                pagesize_pop=this.pageSize;
            }
        }
    });

    
    

    
//////////////////////// 弹出窗口的 操作:添加医嘱项 //////////////////////////////////////////////
        var AddOrder=function(){
                //2022-09-13 医嘱子分类类型为药品类型的数据不允许在医嘱项界面添加
                var arcictype=tkMakeServerCall("web.DHCBL.CT.ARCItemCat","GetTypeByARCICRowId",Ext.getCmp("arcitemcat1").getValue());
                if ((arcictype=="R"))  //||(arcictype=="M")
                {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:'此界面不允许直接添加药品，请核对数据!',  ///材料  
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                     return;
                }
                arcimrowid="",ArcItmMastStr="", ZeroFeeStr="", AddOrdLinkTar="",ArcimCheckboxStr=""
                if(winformDetail.getForm().isValid()==false){
                     Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误或者必填项为空！</font>');
                     return;
                }
                
                if (Ext.getCmp("todate1").getValue()!="" & Ext.getCmp("fromdate1").getValue()!="") {
                    var fromdate=Ext.getCmp("fromdate1").getValue().format("Ymd");
                    var todate=Ext.getCmp("todate1").getValue().format("Ymd");
                    if (fromdate > todate) {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:'开始日期不能大于结束日期!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                     return;
                    }
                }
                /*
                if (Ext.getCmp("zerofee1").getValue()=="1")   //是否 [零收费] 医嘱项?
                {
                    if (Ext.getCmp("chargesubcat1").getValue()=="") {
                         Ext.Msg.show({
                                    title:'提示',
                                    msg:'收费子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    if (Ext.getCmp("emcsubcat1").getValue()=="") {
                         Ext.Msg.show({
                                    title:'提示',
                                    msg:'核算子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    if (Ext.getCmp("acctsubcat1").getValue()=="") {
                         Ext.Msg.show({
                                    title:'提示',
                                    msg:'会计子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    if (Ext.getCmp("inpatsubcat1").getValue()=="") {
                         Ext.Msg.show({
                                    title:'提示',
                                    msg:'住院子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    if (Ext.getCmp("outpatsubcat1").getValue()=="") {
                          Ext.Msg.show({
                                    title:'提示',
                                    msg:'门诊子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    if (Ext.getCmp("mrsubcat1").getValue()=="") {
                         Ext.Msg.show({
                                    title:'提示',
                                    msg:'病案首页子分类不能为空!',
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                         return
                    }
                    ZeroFeeStr=Ext.getCmp("chargesubcat1").getValue()+"^"+Ext.getCmp("emcsubcat1").getValue()+"^"+Ext.getCmp("acctsubcat1").getValue()+"^"+Ext.getCmp("inpatsubcat1").getValue()+"^"+Ext.getCmp("outpatsubcat1").getValue()+"^"+Ext.getCmp("mrsubcat1").getValue()+"^"+Ext.getCmp("MCNew_com1").getValue();
                }
                */
                //新增关联收费项目
                var tarcount = associatestore.getCount();
                
                var NewLinkStr="";
                if(tarcount!=0){
                    AddOrdLinkTar="";
                    associatestore.each(function(record){
                        if(AddOrdLinkTar!="") AddOrdLinkTar = AddOrdLinkTar+"*";
                        if (NewLinkStr!="")
                        {
                            NewLinkStr=NewLinkStr+"&"+record.get('tarDate')+"^"+record.data['tarDateTo']
                        }
                        else
                        {
                            NewLinkStr=record.get('tarDate')+"^"+record.data['tarDateTo']
                        }
                        
                        AddOrdLinkTar = AddOrdLinkTar+record.get('olttariffdr')+'^'+record.get('tarnum')+'^'+record.get('tarDate')+'^'+record.get('tarDateTo')+'^'+record.get('OLTBascPriceFlag')+'^'+record.get('OLTBillOnceFlag')
                    }, this);
                }else{
                    AddOrdLinkTar="";
                }
                
                
                if (tarcount>1)
                {
                    var priceflag=tkMakeServerCall("web.DHCBL.CT.DHCOrderLinkTar","GetPriceFlag",Ext.getCmp("arcitemcat1").getValue(),tarcount,"");
                    if (priceflag>0) {
                         Ext.Msg.show({
                                        title:'提示',
                                        msg:'医嘱子分类为Price类型的医嘱不能关联多条收费项，请核对数据!',
                                        minWidth:240,
                                        icon:Ext.Msg.WARNING,
                                        buttons:Ext.Msg.OK
                                    });
                         return
                    }
                }
                ArcItmMastStr=Ext.getCmp("ordercode1").getValue()+"^"+Ext.getCmp("orderdesc1").getValue()+"^"+Ext.getCmp("orderabbrev1").getValue()+"^"+Ext.getCmp("arcitemcat1").getValue()+"^"+Ext.getCmp("billgroupother1").getValue();  ///1-5
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("subbillgroupother1").getValue()+"^"+Ext.getCmp("billunit1").getValue()+"^"+Ext.getCmp("defaultpriority1").getValue()+"^"+Ext.getCmp("fromdate1").getRawValue()+"^"+Ext.getCmp("todate1").getRawValue();  ///6-10
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("orderadvice1").getValue()+"^"+Ext.getCmp("form_servicegroup1").getValue()+"^"+Ext.getCmp("material1").getValue()+"^"+Ext.getCmp("orderaliasinput1").getValue()+"^"+Ext.getCmp("ARCIMDerFeeRulesDR1").getValue();     //11-15
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp('winARCIMText1F').getValue()+"^"+Ext.getCmp('winARCIMText2F').getValue()+"^"+Ext.getCmp('winARCIMText3F').getValue()+"^"+Ext.getCmp('winARCIMText4F').getValue()+"^"+Ext.getCmp('winARCIMText5F').getValue();     ///16-20
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMPatientOrderFile11").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile21").getValue()+"^"+Ext.getCmp("ARCIMPatientOrderFile31").getValue()+"^"+Ext.getCmp("ARCIMMaxCumDose1").getValue()+"^"+Ext.getCmp("ARCIMMaxQtyPerDay1").getValue();  //21-25
                ArcItmMastStr=ArcItmMastStr+"^"+Ext.getCmp("ARCIMMaxQty1").getValue();  ///26
                
                ArcimCheckboxStr=Ext.getCmp('winARCIMChgOrderPerHour').getValue()+"^"+Ext.getCmp('winARCIMDeceasedPatientsOnly').getValue()+"^"+Ext.getCmp('winARCIMDisplayCumulative').getValue()+"^"+ Ext.getCmp('winARCIMUseODBCforWord').getValue()+"^"+Ext.getCmp('winARCIMRestrictEM').getValue();
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('winARCIMRestrictIP').getValue()+"^"+ Ext.getCmp('winARCIMRestrictOP').getValue()+"^"+Ext.getCmp('winARCIMRestrictHP').getValue()+"^"+Ext.getCmp('winARCIMSensitiveOrder').getValue()+"^"+Ext.getCmp("independentorder1").getValue();
                ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp("nostock1").getValue()+"^"+Ext.getCmp("ARCIMSensitive1").getValue()+"^"+Ext.getCmp("ARCIMDefSensitive1").getValue()+"^"+Ext.getCmp("winARCIMAllowInputFreq").getValue();
                //ofy6 
				ArcimCheckboxStr=ArcimCheckboxStr+"^"+Ext.getCmp('winARCIMScanCodeBilling').getValue()  //15
                
                Ext.Ajax.request({
                    url:ARCIM_Save_ACTION_URL,
                    method:'POST',
                    params:{
                            'arcimrowid':'',
                            'ArcItmMastStr':ArcItmMastStr,  //新增医嘱项数据串
                            'ZeroFeeStr':ZeroFeeStr,        //关联零收费项目串
                            'AddOrdLinkTar':AddOrdLinkTar,  //关联收费项数据串
                            'ArcimCheckboxStr':ArcimCheckboxStr,
                            'LinkHospId':hospComp.getValue()
                    },
                    callback:function(options, success, response){
                        if(success){
                            var jsonData = Ext.util.JSON.decode(response.responseText);
                            if(jsonData.success == 'true'){
                                    var myrowid = jsonData.id;
                                    
                                    //// 保存国家/地区标准编码 20160519
                                    Ext.BDP.NationalCodeModFun(Ext.BDP.FunLib.TableName,myrowid)
                                         
                                    MultiAddAgeSex(myrowid);
                                    MultiAddAlias(myrowid);
                                    MultiAddRecLoc(myrowid);     
                                    MultiAddExtCode(myrowid);  
                                    MultiAddHosp(myrowid);
                                    //MultiAddAllergy(myrowid);
                                    win.hide();
                                    Ext.Msg.show({
                                                title:'提示',
                                                msg:'新增医嘱成功!',
                                                icon:Ext.Msg.INFO,
                                                buttons:Ext.Msg.OK,
                                                fn:function(btn){       
                                                    var startIndex = grid.getBottomToolbar().cursor;
                                                    grid.getStore().load({params:{ID:myrowid},
                                                        ///2016-2-23 chenying
                                                        callback: function(records, options, success){
                                                             if (success)
                                                             {
                                                                //Ext.getCmp('grid').fireEvent('rowclick',this); 
                                                                grid.getSelectionModel().selectRow(0,true)
                                                                selectMast()
                                                                
                                                             }
                                                    
                                                        }
                                                    
                                                    
                                                    });
                                                }
                                            });
                                        }
                                    else{
                                            var errorMsg ='';
                                            if(jsonData.info){
                                                errorMsg='<br />'+jsonData.info
                                            }
                                            Ext.Msg.show({
                                                            title:'提示',
                                                            msg:errorMsg,
                                                            minWidth:210,
                                                            icon:Ext.Msg.ERROR,
                                                            buttons:Ext.Msg.OK
                                                        });
                                         }
                                  }
                             }
                    })
    };  
    /*
    ////////////////////////////////////药物搜索按钮 //////////////////////////////////////////
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                iconCls : 'icon-search',
                text : '搜索',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                handler : function() {
                    gridDrug.getStore().baseParams={            
                            code : Ext.getCmp("TextCode").getValue(),
                            desc : Ext.getCmp("TextDesc").getValue()
                    };
                    gridDrug.getStore().load({
                        params : {
                                    start : 0,
                                    limit : pagesize_pop
                                }
                        });
                    }
            });
            
    //////////////////////////////药物重置按钮 /////////////////////////////////////////////
   var resetGridDrug=function() {
            Ext.getCmp("TextCode").reset();
            Ext.getCmp("TextDesc").reset();
            gridDrug.getStore().baseParams={code:'',name:''};
            gridDrug.getStore().load({
                params : {
                            start : 0,
                            limit : pagesize_pop
                        }
                });
            }
                    
    //////////////////////医嘱项 重置按钮//////////////////////////////////////////////////////////
    var btnRefresh = new Ext.Button({
            id : 'btnRefresh',
            iconCls : 'icon-refresh',
            text : '重置',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
            handler : resetGridDrug 
    });
    var drugSearchBar = new Ext.Toolbar({
                id : 'drugSearchBar',
                items : ['医嘱代码', {
                            xtype : 'textfield',
                            id : 'TextCode',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
                        }, '-',
                        '医嘱名称', {
                            xtype : 'textfield',
                            id : 'TextDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
                        }, '-', btnSearch, '-', btnRefresh, '->'
                ]
            });
    var gridDrug = new Ext.grid.GridPanel({
        title: '药物查找',
        header: false,
        store: storeDrug,
        columns: [{
            header:'PHCDRowId',
            dataIndex:'PHCDRowId',
            hidden:true
        },{
            header:'医嘱代码',
            dataIndex:'PHCDCode',
            sortable: true
        },{
            header:'医嘱名称',
            id:'PHCDName',
            dataIndex:'PHCDName',
            sortable: true
        }],
        trackMouseOver: true,
        stripeRows: true,
        autoScroll: true,
        autoExpandColumn: 'PHCDName',
        autoExpandMin: 150,
        sm: new Ext.grid.RowSelectionModel({singleSelect: true}), 
        viewConfig: {forceFit: true},
        columnLines : true,  
        tbar:drugSearchBar,
        bbar: pagingToolbarDrug,
        listeners:{
            'contextmenu':function(e){
                e.stopEvent();
            },
            'rowcontextmenu':function(grid,rowIndex,e){
                this.getSelectionModel().selectRow(rowIndex);
                e.preventDefault();
            },
            'rowdblclick':function(){
                    var record=gridDrug.getSelectionModel().getSelected();
                    Ext.getCmp("drugmastcode").setValue(record.get('PHCDCode'));
                    winDrug.hide();
                }
            }
    });

    gridDrug.addListener('rowdblclick',function(grid,rowIndex,e){
        var record=grid.store.getAt(rowIndex);
        Ext.getCmp("drugmastcode").setValue(record.get('PHCDCode'));
    });
    
    */
   
    
    ////////////////////////////////tabpanel 放大镜放大镜////////////////////////////////////////////
    ///修改
    var genLookup = function(){
        if(lookup&&lookup.store){
            lookup.doSearch([document.getElementById('tarcode').value,document.getElementById('tarname').value,hospComp.getValue()]);
        }else{
            lookup  = new dhcc.icare.Lookup({
                //lookupListComponetId: 1872,
                width:600,
                resizeColumn:false,
                lookupPage: 'dhc.taritemlist',
                lookupName: 'tarname',  //放大镜关联的输入框id
                listClassName: 'web.DHCBL.CT.DHCOrderLinkTar',
                listQueryName: 'TaritemList',
                displayField: 'taridesc',
                listProperties: [document.getElementById('tarcode').value,document.getElementById('tarname').value,hospComp.getValue()],
                listeners:{
                    selectRow: function(str){
                        var tarcodetemp=str.split("^");
                        Ext.getCmp('tarcode').setValue(tarcodetemp[1]); //设置收费关联收费项目代码
                        Ext.getCmp('tarname').setValue(tarcodetemp[2]); //设置收费关联收费项目代码
                        tarInfo = str;                  
                    }
                }
            });
        }
    };
    
    /////////////////////////////////医嘱复制  药物查找的lookup//////////////////////////////////////////////
        ////////////////////////////////tabpanel 放大镜放大镜////////////////////////////////////////////
    var copygenLookup = function(){
        
        if(copylookup&&copylookup.store){
            copylookup.doSearch([document.getElementById('tarcode2').value,document.getElementById('tarname2').value,hospComp.getValue()]);
        }else{
            copylookup  = new dhcc.icare.Lookup({
                //lookupListComponetId: 1872,
                width:600,
                resizeColumn:false,
                lookupPage: 'dhc.taritemlist',
                lookupName: 'tarname2',
                listClassName: 'web.DHCBL.CT.DHCOrderLinkTar',
                listQueryName: 'TaritemList',
                displayField: 'taridesc',
                listProperties: [document.getElementById('tarcode2').value,document.getElementById('tarname2').value,hospComp.getValue()],
                listeners:{
                    selectRow: function(str){
                        var tarcodetemp=str.split("^");
                        Ext.getCmp('tarcode2').setValue(tarcodetemp[1]); //设置收费关联收费项目代码
                        Ext.getCmp('tarname2').setValue(tarcodetemp[2]);  ///设置收费项的名称
                        tarInfo = str;                  
                    }
                }
            });
        }
    };
    ////////////////////////////////////window 的 收费项 放大镜///////////////////////////////
    var wingenLookup = function(){
        if(winlookup&&winlookup.store){
            winlookup.doSearch([Ext.getCmp('tarcode1').getValue(),Ext.getCmp('tarname1').getValue(),hospComp.getValue()]);
        }else{
            winlookup  = new dhcc.icare.Lookup({
                //lookupListComponetId: 1872,
                width:600,
                resizeColumn:false,
                lookupPage: 'dhc.taritemlist',
                lookupName: 'tarname1',
                listClassName: 'web.DHCBL.CT.DHCOrderLinkTar',
                listQueryName: 'TaritemList',
                displayField: 'taridesc',
                listProperties: [document.getElementById('tarcode1').value,document.getElementById('tarname1').value,hospComp.getValue()],
                listeners:{
                    selectRow: function(str){
                        var tarcodetemp=str.split("^");
                        Ext.getCmp('tarcode1').setValue(tarcodetemp[1]); //设置收费关联收费项目代码
                        Ext.getCmp('tarname1').setValue(tarcodetemp[2]);  ///设置收费项的名称
                        tarInfo = str;                  
                    }
                }
            });
        }
    };
    
    /////////////////////////////医嘱项修改时的form 面板//////////////////////////////////////////////////////
    
    
   
   
  
    /**---------创建一个供增加和修改使用的form-----------*/
    var newtarWinForm = new Ext.form.FormPanel({
                id : 'newtarWinForm',                                        //--------FORM标签的id                                    
                //title:'基本信息',
                autoScroll:true,  ///滚动条
                //baseCls : 'x-plain',//form透明,不显示框框
                labelAlign : 'right',
                labelWidth : 100,
                split : true,
                frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影         
                waitMsgTarget : true,
                defaults : {
                    anchor : '95%',
                    bosrder : false
                },
                items : [{
                            xtype:'fieldset',
                            title:'结束收费项对照',
                            autoHeight:true,
                            labelAlign : 'right',
                            items:[{
                                layout:'column',
                                border:false,
                                items:[{
                                    layout: 'form',
                                    labelWidth:100,
                                    columnWidth: '.5',
                                    border:false,
                                    defaults: {anchor:'95%'},
                                    items: [{
                                        fieldLabel: '<font color=red>*</font>开始日期',
                                        xtype:'datefield',
                                        id:'oldOLTStartDate',
                                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('oldOLTStartDate'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('oldOLTStartDate')),
                                        name: 'oldOLTStartDate',
                                        format: BDPDateFormat,
                                        enableKeyEvents : true,
                                        listeners : { 
                                            'keyup' : function(field, e){ 
                                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                                            }
                                        }               
                                    }]
                                },{
                                    layout: 'form',
                                    labelWidth:100,
                                    columnWidth: '.4',
                                    border:false,
                                    defaults: {anchor:'90%'},
                                    items: [{
                                        fieldLabel: '结束日期',
                                        xtype:'datefield',
                                        id:'oldOLTEndDate',
                                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('oldOLTEndDate'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('oldOLTEndDate')),
                                        name: 'oldOLTEndDate',
                                        format: BDPDateFormat,
                                        enableKeyEvents : true,
                                        listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                                    }]
                                }]
                            }
                    
                        ]},
                        
                        {
                            xtype:'fieldset',
                            title:'新增收费项对照',
                            autoHeight:true,
                            labelAlign : 'right',
                            items:[{
                                layout:'column',
                                border:false,
                                items:[{
                                    layout: 'form',
                                    labelWidth:100,
                                    columnWidth: '.5',
                                    border:false,
                                    defaults: {anchor:'95%'},
                                    items: [{
                                        fieldLabel: '<font color=red>*</font>开始日期',
                                        xtype:'datefield',
                                        id:'newOLTStartDate',
                                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('newOLTStartDate'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('newOLTStartDate')),
                                        name: 'newOLTStartDate',
                                        format: BDPDateFormat,
                                        enableKeyEvents : true,
                                        listeners : { 
                                            'keyup' : function(field, e){ 
                                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                                            }
                                        }               
                                    },{
                                        fieldLabel: '结束日期',
                                        xtype:'datefield',
                                        id:'newOLTEndDate',
                                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('newOLTEndDate'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('newOLTEndDate')),
                                        name: 'newOLTEndDate',
                                        format: BDPDateFormat,
                                        enableKeyEvents : true,
                                        listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                                    }]
                                },{
                                    layout: 'form',
                                    labelWidth:100,
                                    columnWidth: '.4',
                                    border:false,
                                    defaults: {anchor:'90%'},
                                    items: [{
                                        
                                        fieldLabel: '<font color=red>*</font>数量',
                                        id:'newOLTQty',
                                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('newOLTQty'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('newOLTQty')),
                                        xtype:'numberfield',
                                        decimalPrecision:6,
                                        enableKeyEvents:true,
                                        allowNegative : false,//不允许输入负数
                                        allowDecimals : true,//允许输入小数
                                        style:"ime-mode:disabled",   //不允许中文输入
                                        listeners: {
                                            keydown:function(field, e){
                                                 //数量文本框,只允许输入数字0-9或小数点、delete、backspace键
                                                if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==110)||(e.keyCode==190)||(e.keyCode==8)||(e.keyCode==46)) {}
                                                else {
                                                    e.stopEvent()
                                                }
                                            }   
                                          }
                                    }, {
                                        fieldLabel: '基价模式',
                                        xtype : 'checkbox',
                                        id:'newOLTBascPriceFlag',
                                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('newOLTBascPriceFlag'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('newOLTBascPriceFlag')),
                                        checked:false
                                    }, {
                                        fieldLabel: '多部位计价一次',
                                        xtype : 'checkbox',
                                        id:'newOLTBillOnceFlag',
                                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('newOLTBillOnceFlag'),
                                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('newOLTBillOnceFlag')),
                                        checked:false
                                    }]
                                }]
                            }
                    
                        ]}
                        
                        ]
            });
            
    /**---------增加、修改操作弹出的窗口-----------*/
    var newtarwin = new Ext.Window({
        title : '',
        width : 770,
        minWidth:700,
        height : 330,
        layout : 'fit',                                                 //----------布局会充满整个窗口，组件自动根据窗口调整大小
        plain : true,                                                   //----------true则主体背景透明
        modal : true,//在页面上放置一层遮罩,确保用户只能跟window交互
        frame : true,                                                   //----------win具有全部阴影，若为false则只有边框有阴影
        //autoScroll : true,
        //collapsible : true,
        hideCollapseTool : true,
        titleCollapse : true,
        bodyStyle : 'padding:3px',
        buttonAlign : 'center',
        closeAction : 'hide',                                          //-----------关闭窗口后执行隐藏命令
        items : newtarWinForm,                                             //-----------将增加和修改的表单加入到win窗口中
        buttons : [{
            text : '保存',
            iconCls : 'icon-save',
            id:'newlink_save_btn',
            disabled : Ext.BDP.FunLib.Component.DisableFlag('newlink_save_btn'),
            //formBind:true,
            handler : function() {                                     //-----------保存按钮下调用的函数
            
                        var gsm = AssociateTaritem.getSelectionModel();// 获取选择列
                        var rows = gsm.getSelections();// 根据选择列获取到所有的行
                
                        ///校验日期，数量，
                        if (Ext.getCmp("newOLTQty").getValue()=="")
                        {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"数量不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                                return;
                        }
                        
                        
                        if (Ext.getCmp("oldOLTEndDate").getRawValue()=="")
                        {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"结束收费项对照 结束日期不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                                return;
                        }
                        
                        var todate=Ext.getCmp("oldOLTEndDate").getValue().format("Ymd");
                        var todaydateymd=(new Date()).format("Ymd");
                        if ((todate < todaydateymd)&&(rows[0].get('associaterowid')=="")) {
                            Ext.Msg.show({
                                            title : '提示',
                                            msg : '结束对照关系的结束日期不能早于今天!',
                                            minWidth : 200,
                                            icon : Ext.Msg.ERROR,
                                            buttons : Ext.Msg.OK
                                        });
                            return;
                        }
                       
                        
                        if (Ext.getCmp("newOLTStartDate").getRawValue()=="")
                        {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"新增收费项对照 开始日期不能为空!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                                return;
                        }
                        if (Ext.getCmp("newOLTStartDate").getValue().format("Ymd")<todaydateymd)
                        {
                                Ext.Msg.show({
                                            title:'提示',
                                            msg:"新增收费项对照 开始日期不能早于今天!",
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                         });
                                return;
                        }
                        
                        
                        if (Ext.getCmp("oldOLTEndDate").getValue()!="" & Ext.getCmp("newOLTStartDate").getValue()!="") {
                            var fromdate=Ext.getCmp("newOLTStartDate").getValue().format("Ymd");
                            var todate=Ext.getCmp("oldOLTEndDate").getValue().format("Ymd");
                            if (fromdate <= todate) {
                                Ext.Msg.show({
                                                title : '提示',
                                                msg : '新增对照关系的开始日期必须大于结束对照关系的结束日期!',
                                                minWidth : 200,
                                                icon : Ext.Msg.ERROR,
                                                buttons : Ext.Msg.OK
                                            });
                                return;
                            }
                           
                        }
                        
                        
                        var NewLinkTar_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=NewLinkTar";
                        var infostr=rows[0].get('associaterowid')+"^"+rows[0].get('olttariffdr')+"^"+Ext.getCmp("oldOLTEndDate").getRawValue()+"^"+Ext.getCmp("newOLTStartDate").getRawValue()+"^"+Ext.getCmp("newOLTEndDate").getRawValue()+"^"+Ext.getCmp("newOLTQty").getValue()+"^"+Ext.getCmp("newOLTBascPriceFlag").getValue()+"^"+Ext.getCmp("newOLTBillOnceFlag").getValue()
                        
                        
                        var newlink=tkMakeServerCall("web.DHCBL.CT.DHCOrderLinkTar","NewLinkTar",infostr);                      
                        //alert(newlink)
                        OltRowid="";  //清空选择的关联收费项目Rowid
                        tarInfo=""; 
                        comValue=0, PerPrice=0 ,totalPrice=0;
                        
                        newtarwin.hide()
                        //数据保存成功后,重新加载医嘱与收费项目的关联明细
                        updateassociatestore.load({ 
                            params: {
                              arcimrowid:arcimrowid,
                              hospid:hospComp.getValue()
                            }, 
                            callback: function(r, options, success){
                                if(success){
                                    ///添加完关联收费项后刷新合计金额
                                    var price=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetOrderPrice",arcimrowid,hospComp.getValue());                       
                                    OrderPriceTb.setText("收费项目合计金额为" +price+"元");
                                    
                                    if (AssociateTaritem.selModel.hasSelection())
                                    {
                                        var linenum=AssociateTaritem.getSelectionModel().lastActive;  //取消选择行
                                        AssociateTaritem.getSelectionModel().deselectRow(linenum);
                                    }
                                    
                                    if (Ext.getCmp("grid").selModel.hasSelection())
                                    {
                                        if (grid.getSelectionModel().getSelected().data['orderprice']!=price)
                                        {
                                            var nub = Ext.getCmp("grid").getSelectionModel().lastActive;
                                            Ext.getCmp("grid").getStore().getAt(nub).set("orderprice",price);
                                        }
                                    }                       
                                    
                                }
                                else{
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:"医嘱与收费项目关联明细加载失败!",
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                 });
                                }
                             }
                            });
                        
                    
            }
        }, {
            text : '关闭',
            iconCls : 'icon-close',
            handler : function() {
                newtarwin.hide();
            }
        }],
        listeners : {
            "show" : function() {
                
            },
            "hide" : function() {
                
                Ext.BDP.FunLib.Component.FromHideClearFlag;
                newtarWinForm.getForm().reset();
                Ext.getCmp("oldOLTStartDate").setDisabled(false)
                Ext.getCmp("oldOLTEndDate").setDisabled(false)
                                            
            },
            "close" : function() {
            }
        } 
    });
    
    ///修改医嘱项
    var formDetail = new Ext.form.FormPanel({
        title:'基本信息',
        frame:true,
        defaults: {anchor:'96%',autoScroll:false},
        items:[{
            xtype:'fieldset',
            title:'医嘱项基本信息',
            labelWidth: 100,
            autoHeight:true,
            items :{
                layout:'column',
                border:false,
                items:[{
                    columnWidth:'.4',
                    layout: 'form',
                    labelWidth: 100,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [{
                    
                        fieldLabel: '<font color=red>*</font>医嘱代码',
                        id:'ordercode',
                        xtype: 'textfield',
                        maxLength:100,
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ordercode'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ordercode'))
                        
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱名称',
                        id:'orderdesc',
                        xtype: 'textfield',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderdesc'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderdesc')),
                        listeners :{
                            'blur':function(f){
                                win.setTitle('添加新医嘱项'+ " -- " + f.getValue());
                                
                            }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱大类',
                        xtype:'bdpcombo',
                        id:'OECOrderCatDR',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ORCATRowId',
                        displayField:'ORCATDesc',
                        store:new Ext.data.JsonStore({
                            url:OrderCatDR_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ORCATRowId','ORCATDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("arcitemcat").setValue("");
                                }
                            }   
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱子类',
                        xtype:'bdpcombo',
                        id:'arcitemcat',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('arcitemcat'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('arcitemcat')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ARCICRowId',
                        displayField:'ARCICDesc',
                        store:arcitemcatds=new Ext.data.JsonStore({
                            url:ItemCat_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCICRowId','ARCICDesc']
                        }),
                        listeners:{
                             'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue(),
                                        ordcat:Ext.getCmp("OECOrderCatDR").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                         }
                    },{
                        fieldLabel: '医嘱优先级', //<font color=red>*</font>
                        xtype:'bdpcombo',
                        //allowBlank:false,
                        id:'defaultpriority',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultpriority'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultpriority')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',   
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'OECPRRowId',
                        displayField:'OECPRDesc',
                        store:new Ext.data.JsonStore({
                            url:defaultpriority_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['OECPRRowId','OECPRCode','OECPRDesc']
                        }) 
                    },{
                        fieldLabel: '医嘱缩写',
                        id:'orderabbrev',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderabbrev'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderabbrev'))
                    },{
                        xtype: 'datefield',
                        fieldLabel: '<font color=red>*</font>开始日期',
                        id:'fromdate',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('fromdate'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('fromdate')),
                        name: 'DateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    },{
                        xtype: 'datefield',
                        fieldLabel: '结束日期',
                        id:'todate',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('todate'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('todate')),
                        name: 'DateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    }]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    labelWidth: 100,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [
                    {
                        fieldLabel: '<font color=red>*</font>账单组',
                        xtype:'bdpcombo',
                        allowBlank:false,
                        
                        id:'billgroupother',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('billgroupother'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billgroupother')),
                        allQuery:'',   
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCBGRowId',
                        displayField:'ARCBGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCBGRowId','ARCBGDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("subbillgroupother").setValue("");  //清空账单亚组的值
                                    
                                }
                            }                           
                    },{
                        fieldLabel: '<font color=red>*</font>账单子组',
                        xtype:'bdpcombo',
                        allowBlank:false,
                        id:'subbillgroupother',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother')),
                        allQuery:'',  
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCSGRowId',
                        displayField:'ARCSGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillSubGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCSGRowId','ARCSGDesc']
                        }),
                        listeners:{
                             'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue(),
                                        ParRef:Ext.getCmp("billgroupother").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                         }                      
                    },{
                            fieldLabel: '账单单位',  //<font color=red>*</font>
                            xtype:'bdpcombo',
                            //allowBlank:false,
                        
                            id:'billunit',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('billunit'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billunit')),
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,  
                            listWidth:250,
                            valueField:'CTUOMRowId',
                            displayField:'CTUOMDesc',
                            store:new Ext.data.JsonStore({
                                 url:BillUnit_ACTION_URL,
                                 root:'data',
                                 totalProperty:'total',
                                 idProperty:'rowid',
                                 fields:['CTUOMRowId','CTUOMDesc'] 
                            })    
                    },{
                            fieldLabel:'费用标准',
                            id:'ARCIMDerFeeRulesDR',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDerFeeRulesDR'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDerFeeRulesDR')),
                            xtype:'bdpcombo',
                            triggerAction:'all', 
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,
                            listWidth:250,
                            valueField:'DFRRowId',
                            displayField:'DFRDesc',
                            store:new Ext.data.JsonStore({
                               url:ARCDerivedFeeRules_ACTION_URL,
                               root: 'data',
                               totalProperty: 'total',
                               idProperty: 'rowid',
                               fields:['DFRRowId','DFRDesc']
                            }) 
                    },{
                            fieldLabel: '服务/材料',
                            xtype:'combo',
                            id:'material',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('material'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('material')),
                            valueField:'rowid',
                            displayField:'code',
                            mode:'local',
                            store: new Ext.data.ArrayStore({
                                fields: ['rowid','code'],
                                data: [['S','服务'],['M','材料']]
                            })
                    },{
                        fieldLabel: '服务组',
                        xtype:'bdpcombo',
                        id:'form_servicegroup',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup')),
                        allQuery:'',   
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,   
                        listWidth:250,
                        valueField:'SGRowId',
                        displayField:'SGDesc',
                        store:new Ext.data.JsonStore({
                             url:resourcegroup_ACTION_URL,
                             root: 'data',
                             totalProperty: 'total',
                             idProperty: 'rowid',
                             fields:['SGRowId','SGDesc']
                        }),
                        listeners:{
                            'beforequery': function(e){
                                this.store.baseParams = {
                                    desc:e.query,
                                    hospid:hospComp.getValue()
                                };
                                this.store.load({params : {
                                            start : 0,
                                            limit : ComboPage
                                }})
                        
                         }
                        }    
                    }
                    
                    ]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    border:false,
                    style:'margin-left:20px',
                    labelAlign:'top',
                    defaults: {msgTarget:'qtip'},
                    items: [{
                            fieldLabel: '医嘱备注',
                            id:'orderadvice',
                            xtype: 'textarea',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('orderadvice'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderadvice'))
                        },{
                        xtype:'checkboxgroup',
                        hideLabel:true,
                        anchor:'90%',
                        layout:'column',
                        ///columns: [0.4, 0.6], 
                        items:[
                            {
                                columnWidth:'.99',
                                layout: 'form',
                                items: [
                                {
                            boxLabel:'独立医嘱',
                            xtype : 'checkbox',
                            id:'independentorder',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('independentorder'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('independentorder')),
                            inputValue:'Y'
                        },{
                            boxLabel:'无库存医嘱',
                            id:'nostock',
                            xtype : 'checkbox',
                            readOnly:true,
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('nostock')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        /////2016-5-11 chenying
                                        var linkedflag=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetLinkedINCRowId",arcimrowid);
                                        //// Y  被库存项关联了，  可以是无库存 也可以是 有库存  ； N时  必须是无库存医嘱
                                        if (linkedflag=="N") 
                                        {
                                            Ext.getCmp("nostock").readOnly = true;
                                        }
                                        else
                                        {
                                            Ext.getCmp("nostock").readOnly = Ext.BDP.FunLib.Component.DisableFlag('nostock');
                                        }
                                        
                                    }
                                }, 
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '没有关联库存项的医嘱，只能是无库存医嘱'  
                                    })  
                                }  
                            
                            }   
                        },{
                            boxLabel:'加急医嘱',
                            id:'ARCIMSensitive',
                            xtype : 'checkbox',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        Ext.getCmp("ARCIMDefSensitive").readOnly = false;
                                    }
                                    else
                                    {
                                        Ext.getCmp("ARCIMDefSensitive").setValue(false)
                                        Ext.getCmp("ARCIMDefSensitive").readOnly = true;
                                    }
                                }
                            }   
                        },{
                            boxLabel:'默认加急',
                            id:'ARCIMDefSensitive',
                            xtype : 'checkbox',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        var ARCIMSensitive=Ext.getCmp("ARCIMSensitive").getValue(); 
                                        if (ARCIMSensitive==false){   
                                            Ext.Msg.alert("提示","加急医嘱才能选择默认加急!"); 
                                            Ext.getCmp("ARCIMDefSensitive").setValue(false);                                        
                                        }
                                    } 
                                 },
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '加急医嘱才能选择默认加急'  
                                    })  
                                }  
                            
                            }   
                        }]
                        
                        
                            }]
                    }]
                }]
            }
        
        },{
            xtype:'fieldset',
            title:'其他信息',
            labelAlign : 'right',
            items:[{
                layout:'column',
                border:false,
                defaults: {
                    labelWidth:100
                },
                items:[{
                    layout: 'form',
                    columnWidth: '.4',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                               fieldLabel : 'Text1',
                               name : 'ARCIMText1',
                               xtype: 'textfield',
                               id:'ARCIMText1F',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText1F'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText1F'))
                        },{
                               fieldLabel : 'Text2',
                               name : 'ARCIMText2',
                               id:'ARCIMText2F',
                               xtype: 'textfield',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText2F'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText2F'))
                        },{
                               fieldLabel : 'Text3',
                               name : 'ARCIMText3',
                               id:'ARCIMText3F',
                               xtype: 'textfield',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText3F'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText3F'))
                        },{
                               fieldLabel : 'Text4',
                               name : 'ARCIMText4',
                               id:'ARCIMText4F',
                               xtype: 'textfield',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText4F'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText4F'))
                        },{
                               fieldLabel : 'Text5',
                               name : 'ARCIMText5',
                               id:'ARCIMText5F',
                               xtype: 'textfield',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText5F'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText5F'))
                       
                        }
                            ]
                },{
                    layout: 'form',
                    border:false,
                    columnWidth: '.3',
                    defaults: {anchor:'90%'},
                    items: [
                    {
                        fieldLabel: '单次最大剂量',
                        name:'ARCIMMaxCumDose',
                        width:60,
                        id:'ARCIMMaxCumDose',
                        xtype:'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose'))
                        
                    },{
                        fieldLabel: '每天最大剂量',
                        name:'ARCIMMaxQtyPerDay',
                        width:60,
                        xtype:'textfield',
                        id:'ARCIMMaxQtyPerDay',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay'))
                    },{
                        fieldLabel: '最大量',
                        name:'ARCIMMaxQty',
                        width:45,
                        xtype:'textfield',
                        id:'ARCIMMaxQty',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty'))
                     }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                            fieldLabel: 'Patient OrderFile1',
                            name:'ARCIMPatientOrderFile1',
                            id:'ARCIMPatientOrderFile1',
                            xtype: 'textfield',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile1'))
                            
                        },{
                            fieldLabel: 'Patient OrderFile2',
                            name:'ARCIMPatientOrderFile2',
                            id:'ARCIMPatientOrderFile2',
                            xtype: 'textfield',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile2'))
                        },{
                            fieldLabel: 'Patient OrderFile3',
                            name:'ARCIMPatientOrderFile3',
                            id:'ARCIMPatientOrderFile3',
                            xtype: 'textfield',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile3'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile3'))  
                        }]
                }]
            }]
        
        },{   
                xtype:'fieldset',
                title:'医嘱项其他选项',
                autoHeight:true,
                labelAlign : 'right',
                labelWidth:150,
                layout:'column',
                items:[{
                            columnWidth: '.3',
                            layout:'form',
                            border:false,
                            items:[{
                           fieldLabel:'小时医嘱',
                           name:'ARCIMChgOrderPerHour',
                           id:'ARCIMChgOrderPerHourF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMChgOrderPerHourF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMChgOrderPerHourF')),
                           //autoHeight:'true',
                           inputValue : 'Y'
                     },{
                           fieldLabel:'使用ODBC模板',
                           name:'ARCIMUseODBCforWord',
                           id:'ARCIMUseODBCforWordF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMUseODBCforWordF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMUseODBCforWordF')),
                           inputValue : 'Y'
                    
                    },{
                           fieldLabel:'显示累计',
                           name:'ARCIMDisplayCumulative',
                           id:'ARCIMDisplayCumulativeF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDisplayCumulativeF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDisplayCumulativeF')),
                           inputValue : 'Y'
                    },{
                           fieldLabel:'允许录入频次',
                           name:'ARCIMAllowInputFreq',
                           id:'ARCIMAllowInputFreqF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowInputFreqF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowInputFreqF')),
                           inputValue : 'Y'
                    }
                        ]
                        },{
                            columnWidth: '.33',
                            border:false,
                            style:'margin-left:20px',
                            layout:'form',
                            items:[{
                               fieldLabel:'限制为急诊病人用',
                               name:'ARCIMRestrictEM',
                               id:'ARCIMRestrictEMF',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictEMF'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictEMF')),
                               inputValue : 'Y'
                        },{
                               fieldLabel:'限制为住院病人用',
                               name:'ARCIMRestrictIP',
                               id:'ARCIMRestrictIPF',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictIPF'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictIPF')),
                               inputValue : 'Y'
                        },{
                               fieldLabel:'限制为门诊病人用',
                               name:'ARCIMRestrictOP',
                               id:'ARCIMRestrictOPF',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictOPF'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictOPF')),
                               inputValue : 'Y'
                        /*},{
                           fieldLabel:'检验条码双份打印',
                           name:'ARCIMDoublePrintFlag',
                           id:'ARCIMDoublePrintFlagF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDoublePrintFlagF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDoublePrintFlagF')),
                           inputValue : 'Y'
                           */
                        }]
                        },{
                            columnWidth: '.37',
                            border:false,
                            labelWidth:170,
                            style:'margin-left:20px',
                            layout:'form',
                            items:[{
                           fieldLabel:'限制为体检病人用',
                           name:'ARCIMRestrictHP',
                           id:'ARCIMRestrictHPF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictHPF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictHPF')),
                           inputValue : 'Y'
                   },{
                           fieldLabel:'限制为已故病人用',
                           name:'ARCIMDeceasedPatientsOnly',
                           id:'ARCIMDeceasedPatientsOnlyF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDeceasedPatientsOnlyF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDeceasedPatientsOnlyF')),
                           inputValue : 'Y'
                    } ,{
                           fieldLabel:'敏感医嘱',
                           name:'ARCIMSensitiveOrder',
                           id:'ARCIMSensitiveOrderF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitiveOrderF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitiveOrderF')),
                           inputValue : 'Y'
                    
                    }
                    //ofy6 
                    ,{
                           fieldLabel:'是否扫码计费',
                           name:'ARCIMScanCodeBilling',
                           //hidden:true,
                           //hideLabel : 'True',
                           id:'ARCIMScanCodeBillingF',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMScanCodeBillingF'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMScanCodeBillingF')),
                           inputValue : 'Y'
                    }
                    ]
                        }]
                    },{
                    xtype:'fieldset',
                    title:'关联收费项目<font color=red>[可选]</font>(开始日期在当天的00:00生效，结束日期在当天的24:00生效，请注意)',
                    labelAlign : 'right',
                    items:[{
                        layout:'column',
                        border:false,
                        defaults: {
                        },
                        items:[{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.5',
                            border:false,
                            defaults: {anchor:'95%'},
                            items: [{
                                fieldLabel: '收费项目代码',
                                xtype:'trigger',            
                                id:'tarcode',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarcode'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarcode')),
                                enableKeyEvents: true,
                                onTriggerClick:genLookup,
                                triggerClass:'x-form-search-trigger',
                                listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                   genLookup();
                                            }
                                        }
                                   }
                            },{
                                   xtype:'trigger',
                                   id: 'tarname',
                                   readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarname'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarname')),
                                   fieldLabel:'<font color=red>*</font>收费项目名称',
                                   enableKeyEvents: true,
                                   onTriggerClick:genLookup,
                                   triggerClass:'x-form-search-trigger',
                                   listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                   genLookup();
                                            }
                                        }
                                   }
                              },{
                                fieldLabel: '结束日期',
                                xtype:'datefield',
                                id:'EffDateTo',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDateTo'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDateTo')),
                                name: 'EffDateTo',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 
                                    'keyup' : function(field, e){ 
                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                    }
                                }
                            }]
                        },{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.4',
                            border:false,
                            defaults: {anchor:'90%'},
                            items: [{
                                fieldLabel: '<font color=red>*</font>开始日期',
                                xtype:'datefield',
                                id:'EffDate',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDate'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDate')),
                                name: 'EffDate',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 
                                    'keyup' : function(field, e){ 
                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                    }
                                }               
                            },{
                                fieldLabel: '<font color=red>*</font>数量',
                                id:'chargenum',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('chargenum'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('chargenum')),
                                xtype:'numberfield',
                                decimalPrecision:6,
                                allowNegative : false,//不允许输入负数
                                allowDecimals : true,//允许输入小数
                                enableKeyEvents:true,
                                style:"ime-mode:disabled",   //不允许中文输入
                                 listeners: {
                                    keydown:function(field, e){
                                        if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==110)||(e.keyCode==190)||(e.keyCode==8)||(e.keyCode==46)) {}
                                        else {e.stopEvent()}
                                    }    //数量文本框,只允许输入数字0-9或小数点、delete、backspace键（110位小键盘小数点  2017-04-20）  
                                  }
                                  
                            }, {
                                fieldLabel: '基价模式',
                                xtype : 'checkbox',
                                id:'OLTBascPriceFlag',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag')),
                                checked:true
                            }, {
                                fieldLabel: '多部位计价一次',
                                xtype : 'checkbox',
                                id:'OLTBillOnceFlag',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag')),
                                checked:true
                            }]
                        }
    
                        ]
                    },
                        
                        {   
                    buttonAlign:'center',
                    buttons:[{
                                text:'添加收费项关联',
                                        
                                            iconCls : 'icon-add',
                                            id:'btn_AddOrderLinkTar',
                                            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderLinkTar'),
                                            handler:function(){
                                                AddOrderLinkTar_remote();
                                                
                                            }
                            },{
                                text:'修改收费项关联',
                                        
                                        iconCls : 'icon-update',
                                        id:'btn_UpdateOrderLinkTar',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateOrderLinkTar'),
                                        handler:function(){
                                            UpdateOrderLinkTar_remote();
                                        }
                            },{
                                text:'重置收费项关联',
                                        
                                        iconCls : 'icon-refresh',
                                        id:'btn_tarclear',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_tarclear'),
                                        handler:function()
                                        {
                                            resetOrderLinkPanelForUpdate()
                                            
                                        }  
                                
                            /*},{
                                text:'结束并重新关联此收费项',   ///2017-11-30 唐山人民 ofy12
                                        iconCls : 'icon-add',
                                        id:'btn_relinktar',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_relinktar'),
                                        handler:function()
                                        {
                                            
                                            
                                            if (arcimrowid=='') {
                                                Ext.Msg.show({
                                                                title:'提示',
                                                                msg:"请先选择一条医嘱项!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                             });
                                                return;
                                            }
                                            if (OltRowid=='') {
                                                Ext.Msg.show({
                                                                title:'提示',
                                                                width:200,
                                                                msg:"未选择医嘱项与收费项目关联!",
                                                                icon:Ext.Msg.ERROR,
                                                                buttons:Ext.Msg.OK
                                                             });
                                                return;
                                            }
                                            
                                            
                                            var gsm = AssociateTaritem.getSelectionModel();// 获取选择列
                                            var rows = gsm.getSelections();// 根据选择列获取到所有的行
                                            newtarWinForm.getForm().reset();
                                            Ext.getCmp("oldOLTStartDate").setDisabled(false)
                                            Ext.getCmp("oldOLTEndDate").setDisabled(false)
                                            
                                            var oldOLTStartDate=rows[0].get('tarDate')
                                            Ext.getCmp("oldOLTStartDate").setValue(oldOLTStartDate)
                                            
                                            var oldOLTEndDate=rows[0].get('tarDateTo')
                                            if (oldOLTEndDate!="") Ext.getCmp("oldOLTEndDate").setValue(oldOLTEndDate)
                                            else Ext.getCmp("oldOLTEndDate").setValue(TodayDate)
                                            
                                            
                                            Ext.getCmp("newOLTStartDate").setValue(TomorrowDate)
                                            Ext.getCmp("newOLTEndDate").setValue("")
                                            Ext.getCmp("newOLTQty").setValue("")
                                            Ext.getCmp("newOLTBascPriceFlag").setValue(false)
                                            Ext.getCmp("newOLTBillOnceFlag").setValue(false)
                                            
                                            Ext.getCmp("oldOLTStartDate").setDisabled(true)
                                            if (oldOLTEndDate!="") 
                                            {
                                                Ext.getCmp("oldOLTEndDate").setDisabled(true)
                                            }
                                            else
                                            {
                                                Ext.getCmp("oldOLTEndDate").setDisabled(Ext.BDP.FunLib.Component.DisableFlag('oldOLTEndDate'))
                                            }
                                            newtarwin.setTitle('结束原有对照数据并新增收费项对照');
                                            newtarwin.setIconClass('icon-update');
                                            newtarwin.show();
                                            
                                            
                                        
                                            
                                        }  
                                */
                            }]
                }
                    ]
            },AssociateTaritem]
            /*,
        buttonAlign:'center',
        buttons:[{
            text: '保存',
            width: 100,
            iconCls:'icon-save',
            id:'DetailForm_update_btn',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('DetailForm_update_btn'),  
            handler:SaveForUpdateARCIM
        }]*/
    });
    
    
    ///////////////////////////////////////window  tabpanel 里的////////////////////////////////////////////////
    
    
    
    ////添加医嘱项 弹出form
    var winformDetail = new Ext.form.FormPanel({
        id:'winformdetail',
        title:'基本信息',
        labelWidth: 100,
        defaults: {anchor:'96%'},
        frame:true,
        items:[{
            xtype:'fieldset',
            
            title:'医嘱项基本信息',
            items :{
                layout:'column',
                border:false,
                items:[{
                    columnWidth:'.4',
                    layout: 'form',
                    labelWidth: 100,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>医嘱代码',
                        dataIndex:'code',
                        allowBlank:false,
                        id:'ordercode1',
                        maxLength:100,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ordercode1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ordercode1')),
                        listeners :{
                            specialkey: function(field, e){ 
                                ///2019-08-02 输入一个字符串，回车查询以这个字符串开头的最大码并自动+1(要求：字符串区分大小写，且字符串后面只有数字
                                if (e.getKey() == e.ENTER) {
                                    var searchstr=Ext.getCmp('ordercode1').getValue()
                                    var maxcode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetMaxCode",searchstr,hospComp.getValue());
                                    Ext.getCmp('ordercode1').setValue(maxcode)
                                }
                            },
                            render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '回车查询最大码并自动加1'  
                                    })  
                                }  
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱名称',
                        id:'orderdesc1',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderdesc1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderdesc1')),
                        listeners :{
                            'blur':function(f){
                                win.setTitle('添加新医嘱项'+ " -- " + f.getValue());
                                
                                ///根据医嘱名称自动获取拼音首字母大写别名
                                var pinyins=Pinyin.GetJPU(Ext.getCmp("orderdesc1").getValue());
                                Ext.getCmp("orderaliasinput1").setValue(pinyins);
                            }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱大类',
                        xtype:'bdpcombo',
                        id:'OECOrderCatDR1',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR1')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ORCATRowId',
                        displayField:'ORCATDesc',
                        store:new Ext.data.JsonStore({
                            url:OrderCatDR_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ORCATRowId','ORCATDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("arcitemcat1").setValue("");
                                    
                                    var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                                    if (flag==1)
                                    {
                                        var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR1").getValue()+"^"+Ext.getCmp("arcitemcat1").getValue()+"^1",hospComp.getValue());
                                        Ext.getCmp("ordercode1").setValue(MaxCode) 
                                    }
                    
                                },
                                'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                        }
                            
                            
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱子类',
                        xtype:'bdpcombo',
                        id:'arcitemcat1',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('arcitemcat1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('arcitemcat1')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ARCICRowId',
                        displayField:'ARCICDesc',
                        store:new Ext.data.JsonStore({
                                url:ItemCat_ACTION_URL,
                                root: 'data',
                                totalProperty: 'total',
                                idProperty: 'rowid',
                                fields:['ARCICRowId','ARCICCode','ARCICDesc']
                            }),
                 
                        listeners:{
                                'select': function(field,e){
                                
                                    ///ofy3 河南省人民医院 医嘱项代码根据规则生成  医嘱大类代码（2位）+6位生成码 共8位
                                    /*var itemcatid=Ext.getCmp('arcitemcat1').getValue()
                                    var RuleCode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetMaxCodeByItemCat",itemcatid);                       
                                    Ext.getCmp("ordercode1").setValue(RuleCode);  //清空账单亚组的值
                                     */
                                    var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                                    if (flag==1)
                                    {
                                        var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR1").getValue()+"^"+Ext.getCmp("arcitemcat1").getValue()+"^1",hospComp.getValue());
                                        Ext.getCmp("ordercode1").setValue(MaxCode) 
                                    }
                                },
                                'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue(),
                                            ordcat:Ext.getCmp("OECOrderCatDR1").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                                                
                                 }
                                
                                
                        }   
                    
                            
                            
                    },{
                        fieldLabel: '医嘱优先级',  //<font color=red>*</font>
                        xtype:'bdpcombo',
                        //allowBlank:false,
                        id:'defaultpriority1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultpriority1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultpriority1')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',   
                        pageSize:ComboPage,
                        minChars: 0,   
                        listWidth:250,
                        valueField:'OECPRRowId',
                        displayField:'OECPRDesc',
                        store:new Ext.data.JsonStore({
                                url:defaultpriority_ACTION_URL,
                                root: 'data',
                                totalProperty: 'total',
                                idProperty: 'rowid',
                                fields:['OECPRRowId','OECPRCode','OECPRDesc']
                         }) 
                    },{
                        fieldLabel: '医嘱缩写',
                        id:'orderabbrev1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderabbrev1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderabbrev1'))
                    },{
                        xtype: 'datefield',
                        fieldLabel: '<font color=red>*</font>开始日期',
                        width:80,
                        allowBlank:false,
                        id:'fromdate1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('fromdate1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('fromdate1')),
                        name: 'DateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                        }}
                    },{
                        xtype: 'datefield',
                        fieldLabel: '结束日期',
                        id:'todate1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('todate1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('todate1')),
                        name: 'DateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                        }}
                    }]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    labelWidth: 100,
                    labelPad:1,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [{
                        fieldLabel: '<font color=red>*</font>医嘱别名',
                        id:'orderaliasinput1',
                        allowBlank:false,
                        readOnly:Ext.BDP.FunLib.Component.DisableFlag('orderaliasinput1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderaliasinput1'))
                    },{
                        fieldLabel: '<font color=red>*</font>账单组',
                        xtype:'bdpcombo',
                        allowBlank:false,
                        
                        id:'billgroupother1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('billgroupother1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billgroupother1')),
                        allQuery:'',  //将条件传入csp,然后在csp中获取query值  cwg20120522
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCBGRowId',
                        displayField:'ARCBGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCBGRowId','ARCBGDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("subbillgroupother1").setValue("");  //清空账单亚组的值
                                    
                                },
                            'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                            }                           
                    },{
                        fieldLabel: '<font color=red>*</font>账单子组',
                        width:60,
                        xtype:'bdpcombo',
                        allowBlank:false,
                        
                        id:'subbillgroupother1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother1')),
                        allQuery:'',  //将条件传入csp,然后在csp中获取query值  cwg20120522
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCSGRowId',
                        displayField:'ARCSGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillSubGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCSGRowId','ARCSGDesc']
                        }),
                        listeners:{
                             'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue(),
                                        ParRef:Ext.getCmp("billgroupother1").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                         }      
                    },{
                            fieldLabel:'费用标准',
                            width:60,
                            id:'ARCIMDerFeeRulesDR1',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDerFeeRulesDR1'),
                            xtype:'bdpcombo',
                            triggerAction:'all', 
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,
                            listWidth:250,
                            valueField:'DFRRowId',
                            displayField:'DFRDesc',
                            store:new Ext.data.JsonStore({
                               url:ARCDerivedFeeRules_ACTION_URL,
                               root: 'data',
                               totalProperty: 'total',
                               idProperty: 'rowid',
                               fields:['DFRRowId','DFRDesc']
                            }) 
                    },{
                            fieldLabel: '账单单位',  //<font color=red>*</font>
                            xtype:'bdpcombo',
                            id:'billunit1',
                            //allowBlank:false,
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('billunit1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billunit1')),
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,  //查询条件为空值时,执行查询
                            listWidth:250,
                            valueField:'CTUOMRowId',
                            displayField:'CTUOMDesc',
                            store:new Ext.data.JsonStore({
                                 url:BillUnit_ACTION_URL,
                                 root:'data',
                                 totalProperty:'total',
                                 idProperty:'rowid',
                                 fields:['CTUOMRowId','CTUOMDesc'] 
                            })    
                    },{
                            fieldLabel: '服务/材料',
                            xtype:'combo',
                            id:'material1',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('material1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('material1')),
                            valueField:'rowid',
                            displayField:'code',
                            mode:'local',
                            store: new Ext.data.ArrayStore({
                                fields: ['rowid','code'],
                                data: [['S','服务'],['M','材料']]
                            })
                    },{
                        fieldLabel: '服务组',
                        xtype:'bdpcombo',
                        id:'form_servicegroup1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup1')),
                        allQuery:'',  //将条件传入csp,然后在csp中获取query值  cwg20120522
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,  //查询条件为空值时,执行查询
                        listWidth:250,
                        valueField:'SGRowId',
                        displayField:'SGDesc',
                        store:new Ext.data.JsonStore({
                             url:resourcegroup_ACTION_URL,
                             root: 'data',
                             totalProperty: 'total',
                             idProperty: 'rowid',
                             fields:['SGRowId','SGDesc']
                        }) ,
                        listeners:{
                            'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                            }   
                    }
                    
                    
                    ]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    border:false,
                    labelWidth: 100,
                    style:'margin-left:20px',
                    labelAlign:'top',
                    defaults: {xtype: 'textarea',msgTarget:'qtip'},
                    items: [{
                            fieldLabel: '医嘱备注',
                            id:'orderadvice1',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('orderadvice1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderadvice1'))
                        },{
                        xtype:'checkboxgroup',
                        hideLabel:true,
                        anchor:'90%',
                        layout:'column',
                        ///columns: [0.4, 0.6], 
                        items:[
                            {
                                columnWidth:'.99',
                                layout: 'form',
                                items: [
                                {
                            boxLabel:'独立医嘱',
                            id:'independentorder1',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('independentorder1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('independentorder1')),
                            inputValue:'Y'
                        },{
                            boxLabel:'无库存医嘱',
                            id:'nostock1',
                            readOnly:true,   //添加时 默认是无库存医嘱，不可以修改
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('nostock1')),
                            inputValue:'Y',
                            listeners:{
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '没有关联库存项的医嘱，只能是无库存医嘱'  
                                    })  
                                }  
                            }
                        },{
                            boxLabel:'加急医嘱',
                            id:'ARCIMSensitive1',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive1')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        Ext.getCmp("ARCIMDefSensitive1").readOnly = false;
                                    }
                                    else
                                    {
                                        Ext.getCmp("ARCIMDefSensitive1").setValue(false)
                                        Ext.getCmp("ARCIMDefSensitive1").readOnly = true;
                                    }
                                }
                            }   
                        },{
                            boxLabel:'默认加急',
                            id:'ARCIMDefSensitive1',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive1'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive1')),
                            inputValue:'Y', 
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        var ARCIMSensitive=Ext.getCmp("ARCIMSensitive1").getValue(); 
                                        if (ARCIMSensitive==false){   
                                            Ext.Msg.alert("提示","加急医嘱才能选择默认加急!"); 
                                            Ext.getCmp("ARCIMDefSensitive1").setValue(false);                                        
                                        }
                                    } 
                                 },
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '加急医嘱才能选择默认加急'  
                                    })  
                                }  
                            
                            }  
                        }]
                            }]
                    }]
                }]
            }
        
        },{
            xtype:'fieldset',
            title:'其他信息',
            labelAlign : 'right',
            items:[{
                layout:'column',
                border:false,
                
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.4',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                           fieldLabel : 'Text1',
                           name : 'ARCIMText1',
                           id:'winARCIMText1F',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMText1F'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMText1F'))
                    },{
                           fieldLabel : 'Text2',
                           name : 'ARCIMText2',
                           id:'winARCIMText2F',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMText2F'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMText2F'))
                    },{
                           fieldLabel : 'Text3',
                           name : 'ARCIMText3',
                           id:'winARCIMText3F',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMText3F'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMText3F'))
                    },{
                           fieldLabel : 'Text4',
                           name : 'ARCIMText4',
                           id:'winARCIMText4F',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMText4F'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMText4F'))
                    },{
                           fieldLabel : 'Text5',
                           name : 'ARCIMText5',
                           id:'winARCIMText5F',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMText5F'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMText5F'))
                   }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [
                    {
                        fieldLabel: '单次最大剂量',
                        name:'ARCIMMaxCumDose1',
                        xtype:'textfield',
                        width:60,
                        id:'ARCIMMaxCumDose1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose1'))
                        
                    },{
                        fieldLabel: '每天最大剂量',
                        name:'ARCIMMaxQtyPerDay1',
                        width:60,
                        xtype:'textfield',
                        id:'ARCIMMaxQtyPerDay1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay1'))
                    },{
                        fieldLabel: '最大量',
                        name:'ARCIMMaxQty1',
                        width:45,
                        xtype:'textfield',
                        id:'ARCIMMaxQty1',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty1'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty1'))
                     }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: 'Patient OrderFile1',
                        id:'ARCIMPatientOrderFile11',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile11'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile11')),
                        name: 'ARCIMPatientOrderFile11'
                    },{
                        fieldLabel: 'Patient OrderFile2',
                        id:'ARCIMPatientOrderFile21',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile21'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile21')),
                        name: 'ARCIMPatientOrderFile21'
                    },{
                        fieldLabel: 'Patient OrderFile3',
                        id:'ARCIMPatientOrderFile31',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile31'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile31')),
                        name: 'ARCIMPatientOrderFile31'
                    }]
                }]
            }]
        
        },{   
                xtype:'fieldset',
                title:'医嘱项其他选项',
                autoHeight:true,
                labelAlign : 'right',
                labelWidth:150,
                layout:'column',
                items:[{
                            columnWidth: '.3',
                            layout:'form',
                            border:false,
                            items:[ 
                    {
                               fieldLabel:'小时医嘱',
                               xtype : 'checkbox',
                               name:'ARCIMChgOrderPerHour',
                               id:'winARCIMChgOrderPerHour',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMChgOrderPerHour'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMChgOrderPerHour')),
                               inputValue : 'Y'
                         },{
                           fieldLabel:'使用ODBC模板',
                           name:'ARCIMUseODBCforWord',
                           id:'winARCIMUseODBCforWord',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMUseODBCforWord'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMUseODBCforWord')),
                           inputValue : 'Y'
                       
                        },{
                               fieldLabel:'显示累计',
                               xtype : 'checkbox',
                               name:'ARCIMDisplayCumulative',
                               id:'winARCIMDisplayCumulative',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMDisplayCumulative'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMDisplayCumulative')),
                               inputValue : 'Y'
                        },{
                           fieldLabel:'允许录入频次',
                           name:'ARCIMAllowInputFreq',
                           id:'winARCIMAllowInputFreq',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMAllowInputFreq'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMAllowInputFreq')),
                           inputValue : 'Y'
                        }
                        
                        ]
                        },{
                            columnWidth: '.33',
                            border:false,
                            style:'margin-left:20px',
                            layout:'form',
                            items:[
                            {
                                   fieldLabel:'限制为急诊病人用',
                                   name:'ARCIMRestrictEM',
                                   id:'winARCIMRestrictEM',
                                   xtype : 'checkbox',
                                   readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictEM'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictEM')),
                                   inputValue : 'Y'
                            },{
                                   fieldLabel:'限制为住院病人用',
                                   name:'ARCIMRestrictIP',
                                   id:'winARCIMRestrictIP',
                                   xtype : 'checkbox',
                                   readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictIP'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictIP')),
                                   inputValue : 'Y'
                            },{
                                   fieldLabel:'限制为门诊病人用',
                                   name:'ARCIMRestrictOP',
                                   id:'winARCIMRestrictOP',
                                   xtype : 'checkbox',
                                   readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictOP'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictOP')),
                                   inputValue : 'Y'
                            }
                            //ofy6 
                            ,{
							   fieldLabel:'是否扫码计费',
							   name:'ARCIMScanCodeBilling',
							   //hidden:true,
							   //hideLabel : 'True',
							   xtype : 'checkbox',
							   id:'winARCIMScanCodeBilling',
							   readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMScanCodeBilling'),
							   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMScanCodeBilling')),
							   inputValue : 'Y'
							/*},{
							   fieldLabel:'检验条码双份打印',
							   name:'ARCIMDoublePrintFlag',
							   id:'winARCIMDoublePrintFlag',
							   xtype : 'checkbox',
							   readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMDoublePrintFlag'),
							   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMDoublePrintFlag')),
							   inputValue : 'Y'
							   */
							}] 
                        },{
                            columnWidth: '.37',
                            border:false,
                            labelWidth:170,
                            style:'margin-left:20px',
                            layout:'form',
                            items:[
                    {
                           fieldLabel:'限制为体检病人用',
                           name:'ARCIMRestrictHP',
                           id:'winARCIMRestrictHP',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictHP'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMRestrictHP')),
                           inputValue : 'Y'
                    },{
                           fieldLabel:'限制为已故病人用',
                           xtype : 'checkbox',
                           name:'ARCIMDeceasedPatientsOnly',
                           id:'winARCIMDeceasedPatientsOnly',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMDeceasedPatientsOnly'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMDeceasedPatientsOnly')),
                          inputValue : 'Y'
                    },{
                           fieldLabel:'敏感医嘱',
                           name:'ARCIMSensitiveOrder',
                           id:'winARCIMSensitiveOrder',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('winARCIMSensitiveOrder'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('winARCIMSensitiveOrder')),
                          inputValue : 'Y'
                    }]
                        }]
                    },{
                    xtype:'fieldset',
                    title:'关联收费项目<font color=red>[可选]</font>(开始日期在当天的00:00生效，结束日期在当天的24:00生效，请注意)',
                    labelAlign : 'right',
                    items:[{
                        layout:'column',
                        border:false,
                        defaults: {
                        },
                        items:[{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.5',
                            border:false,
                            defaults: {anchor:'95%'},
                            items: [{
                                fieldLabel: '收费项目代码',
                                id:'tarcode1',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarcode1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarcode1')),
                                xtype:'trigger',            
                                enableKeyEvents: true,
                                onTriggerClick:wingenLookup,
                                triggerClass:'x-form-search-trigger',
                                listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                   wingenLookup();
                                            }
                                        }
                                   }
                            },{
                                   xtype:'trigger',
                                   id: 'tarname1',
                                   readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarname1'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarname1')),
                                   fieldLabel:'<font color=red>*</font>收费项目名称',
                                   enableKeyEvents: true,
                                   onTriggerClick:wingenLookup,
                                   triggerClass:'x-form-search-trigger',
                                   listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                 wingenLookup();
                                            }
                                        }
                                   }
                              },{
                                fieldLabel: '结束日期',
                                xtype:'datefield',
                                id:'EffDateTo1',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDateTo1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDateTo1')),
                                name: 'EffDateTo',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 
                                    'keyup' : function(field, e){ 
                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                    }
                                }
                            }]
                        },{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.4',
                            border:false,
                            defaults: {anchor:'90%'},
                            items: [{
                                fieldLabel: '<font color=red>*</font>开始日期',
                                xtype:'datefield',
                                id:'EffDate1',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDate1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDate1')),
                                name: 'EffDate',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 
                                    'keyup' : function(field, e){ 
                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                                    }
                                }               
                            },{
                                fieldLabel: '<font color=red>*</font>数量',
                                id:'chargenum1',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('chargenum1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('chargenum1')),
                                xtype:'numberfield',
                                decimalPrecision:6,
                                allowNegative : false,//不允许输入负数
                                allowDecimals : true,//允许输入小数
                                enableKeyEvents:true,
                                style:"ime-mode:disabled",   //不允许中文输入
                                 listeners: {
                                    keydown:function(field, e){
                                        if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==110)||(e.keyCode==190)||(e.keyCode==8)||(e.keyCode==46)) {}
                                        else {e.stopEvent()}
                                    }    //数量文本框,只允许输入数字0-9或小数点、delete、backspace键
                                  }
                                  
                            }, {
                                fieldLabel: '基价模式',
                                xtype : 'checkbox',
                                id:'OLTBascPriceFlag1',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag1')),
                                checked:true      
                            }, {
                                fieldLabel: '多部位计价一次',
                                xtype : 'checkbox',
                                id:'OLTBillOnceFlag1',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag1')),
                                checked:true
                            }]
                        }]
                    },
                        
                        {   
                    buttonAlign:'center',
                    buttons:[{
                                text:'添加收费项关联',
                                            iconCls : 'icon-add',
                                            id:'btn_AddOrderLinkTar1',
                                            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderLinkTar1'),
                                            handler:function(){
                                                AddOrderLinkTar();
                                            }
                            },{
                                text:'修改收费项关联',
                                        iconCls : 'icon-update',
                                        id:'btn_UpdateOrderLinkTar1',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateOrderLinkTar1'),
                                        handler:function(){
                                                UpdateOrderLinkTar();
                                        }
                            },{
                                text:'重置收费项关联',
                                        iconCls : 'icon-refresh',
                                        id:'btn_tarclear1',
                                        handler:function()
                                        {
                                            resetOrderLinkPanelForAdd()
                                            
                                        }    
                                
                            },{
                                text:'删除收费项关联',
                                        iconCls : 'icon-delete',
                                        id:'DelOrderLinkTar_del_btn1',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('DelOrderLinkTar_del_btn1'),
                                        handler:function()
                                        {
                                            DelOrderLinkTar();
                                        }         
                            }]
                }
                    
                    
                    
                    
                    ]
            },winAssociateTaritem]
    });
    
    /*var formDetailOther1 = new Ext.form.FormPanel({
        title:'其他明细',
        frame:true,
        defaults : {
                    anchor : '90%',
                    border : false
                },
        items:[{
            layout:'column',
            border: false,
            items:[{
                xtype: 'fieldset',
                title: '药房',
                labelAlign : 'right',
                style:'margin-right:10px;',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.45',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                        fieldLabel: '药物',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugmast',
                        queryParam : 'drugdesc',
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        pageSize:ComboPage,
                        minChars: 0,  //查询条件为空值时,执行查询
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                                     url:drugmast_ACTION_URL,
                                     root: 'results',
                                     queryParam:'drugdesc',
                                     totalProperty: 'totalCount',
                                     idProperty: 'rowid',
                                     fields:['rowid','desc','drgform']
                                }),
                        listeners:{
                            'select': function(t,r,i){  
                        }
                    }
                },{
                        fieldLabel: '药物形态',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugform',
                        mode:'local',
                        pageSize:ComboPage,
                        minChars: 0,  //查询条件为空值时,执行查询
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                            url:drugform_ACTION_URL,
                            root: 'results',
                            queryParam:'drugformselect',
                            totalProperty: 'totalCount',
                            idProperty: 'rowid',
                            fields:['rowid','desc']
                    }),
                        listeners:{
                            'beforequery':function(obj){
                                obj.combo.store.load({
                                    params:{
                                             start:0,
                                             limit:10,
                                             drugformrowid:Ext.getCmp("drugmast").getValue()
                                        }});
                                        return false;
                            }
                        }                    
                },{
                    fieldLabel: 'MIMS/FDB No',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Dose Calculation',
                    name: '',
                    disabled:true
                }]
            },{
                xtype: 'fieldset',
                title: 'Questionaire',
                labelWidth:100,
                labelAlign : 'right',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.55',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                    fieldLabel: 'Order Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Administration Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Result Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Phone Order Review Time (hours)',
                    disabled:true,
                    xtype:'textfield',
                    name: '',
                    id:'PhoneOrderReviewTime'
                }]
            }]
        },{
            xtype:'fieldset',
            title:'其他',
            labelAlign : 'right',
            items:[{
                layout:'column',
                border: false,
                items: [{
                    layout: 'form',
                    columnWidth: '.5',
                    labelWidth:100,
                    defaults: {xtype:'textfield',anchor:'90%'},
                    items: [{
                                fieldLabel: '账单描述',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '二选一描述',
                                disabled:true
                            },{
                                fieldLabel: 'Consultation Department',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: 'Dental State',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '核实医嘱复制天数',
                                disabled:true
                            },{
                                fieldLabel: '模板',
                                disabled:true
                            },{
                                fieldLabel: 'Result Group',
                                disabled:true
                            },{
                                fieldLabel: 'Result Display Group',
                                xtype:'combo',
                                disabled:true
                        }]
                },{
                        columnWidth:'.5',
                        layout: 'form',
                        border:false,
                        style:'margin-left:20px',
                        labelAlign:'top',
                        defaults: {width:180,xtype: 'textarea',msgTarget:'qtip'},
                        items: [{
                            fieldLabel: 'Booking Notes',
                            disabled:true
                        },{
                            fieldLabel: 'Processing Notes',
                            disabled:true
                        }]
                }]
            }]
        }],
        buttonAlign:'center',
        buttons:[{
            text: '保存',
            width: 100,
            iconCls:'icon-save',
            id:'DetailForm1_update_btn' ,
            disabled:Ext.BDP.FunLib.Component.DisableFlag('DetailForm1_update_btn'),
            handler:SaveForUpdateARCIM
        }]
    });
    */
    
    ///修改医嘱项时 关联零收费项
    var formDetailOther2 = {
        xtype:"form",
        title:'关联零收费项',
        labelAlign : 'right',
        frame:true,
        items:[{
            xtype:'fieldset',
            title:'与零收费项目的关联<font color=red>（可选）</font>',
            anchor:'96%',
            items:{
                  layout: 'column',          
                  items:[{
                            columnWidth:'.4',
                            layout: 'form',             
                            defaults: {anchor:'90%'},
                            items: [{   
                                xtype:'checkbox',
                                boxLabel:'添加零收费项目关联',
                                id:'zerofee',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('zerofee'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('zerofee')),
                                inputValue:'Y',
                                listeners:{
                                    'check' : function(com, checked){
                                        if(checked){
                                            //enableZeroChargeForUpdate()
                                        }else{
                                            //disableZeroChargeForUpdate()
                                        
                                        }
                                    }
                                }
                            },{
                                fieldLabel:'<font color=red>*</font>收费子分类',
                                xtype:'bdpcombo',
                                id:'chargesubcat',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                                minChars: 0,  //combox值为空时,查询全部
                                listWidth:250,
                                valueField:'TARSCRowId',
                                displayField:'TARSCDesc',
                                store:new Ext.data.JsonStore({
                                    url:SubCate_ACTION_URL,
                                    root: 'data',
                                    totalProperty: 'total',
                                    idProperty: 'rowid',
                                    fields:['TARSCRowId','TARSCCode','TARSCDesc']
                                })              
                            },{
                               fieldLabel:'<font color=red>*</font>核算子分类',
                               xtype:'combo',
                               id:'emcsubcat',
                               triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               listWidth:250,
                               minChars: 0,  //combox值为空时,查询全部
                               valueField:'TARECRowId',
                               displayField:'TARECDesc',
                               store:new Ext.data.JsonStore({
                                    url:EMCCate_ACTION_URL,
                                    root: 'data',
                                    totalProperty: 'total',
                                    idProperty: 'rowid',
                                    fields:['TARECRowId','TARECCode','TARECDesc']
                                })                                      
                            },{
                                fieldLabel:'<font color=red>*</font>会计子分类',
                                xtype:'combo',
                                id:'acctsubcat',
                                triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               minChars: 0,  //combox值为空时,查询全部
                               listWidth:250,
                               valueField:'TARACRowId',
                               displayField:'TARACDesc',
                               store:new Ext.data.JsonStore({
                                 url:AcctCate_ACTION_URL,
                                 root: 'data',
                                 totalProperty: 'total',
                                 idProperty: 'rowid',
                                 fields:['TARACRowId','TARACCode','TARACDesc']
                               })   
                            }]
                        },{
                            columnWidth:'.4',
                            layout: 'form',
                            style:'margin-left:30px',
                            labelWidth:120,
                            defaults: {anchor:'90%'},
                            items: [{
                                fieldLabel:'<font color=red>*</font>住院子分类',
                                xtype:'bdpcombo',
                                id:'inpatsubcat',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo , 
                                minChars: 0,  //combox值为空时,查询全部
                                listWidth:250,
                                valueField:'TARICRowId',
                                displayField:'TARICDesc',
                                store:new Ext.data.JsonStore({
                                     url:InpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARICRowId','TARICCode','TARICDesc']
                               }) 
                        },{
                                fieldLabel:'<font color=red>*</font>门诊子分类',
                                xtype:'bdpcombo',
                                id:'outpatsubcat',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                 pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                 minChars: 0,  //combox值为空时,查询全部
                                 listWidth:250,
                                 valueField:'TAROCRowId',
                                displayField:'TAROCDesc',
                                 store:new Ext.data.JsonStore({
                                     url:OutpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TAROCRowId','TAROCCode','TAROCDesc']
                               }) 
                            },{
                                fieldLabel:'<font color=red>*</font>病案首页子分类',
                                xtype:'bdpcombo',
                                id:'mrsubcat',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,  //combox值为空时,查询全部
                                listWidth:250,
                                valueField:'TARMCRowId',
                                displayField:'TARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MRCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARMCRowId','TARMCCode','TARMCDesc']
                               }) 
                            },{
                                fieldLabel:'新病案首页子分类',
                                xtype:'bdpcombo',
                                id:'MCNew_com',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,  //combox值为空时,查询全部
                                listWidth:250,
                                valueField:'NTARMCRowId',
                                displayField:'NTARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MCNew_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['NTARMCRowId','NTARMCDesc']
                               }) 
                            }]
                         
                        }
                          ]
                    }
            },{
                xtype:'fieldset',
                title:'说明',
                anchor:'96%',
                autoHeight : true,
                //bodyStyle : 'margin-left:10px;',
                html : '<font color=blue>1、关联零收费项后，可在“医嘱项”标签页“医嘱项与收费项目关联明细”表格中查看。<br><br>'
                      +'2、关联了收费项的医嘱项不能再次关联零收费项。<br><br>'
                      +'3、新增的收费项目可在“收费项目维护”中查找，收费项目代码为该医嘱项代码。</font>'
            }]/*,
            buttonAlign:'center',
            buttons:[{
                text: '保存',
                width: 100,
                iconCls:'icon-save',
                id:'DetailForm2_update_btn' ,
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DetailForm2_update_btn'),
                handler:SaveForUpdateARCIM
            }]*/
    };
    
    
    //// tabpanel 页签的内容  ： 其他明细页面
    /*var winformDetailOther1 = new Ext.form.FormPanel({
        title:'其他明细',
        frame:true,
        defaults : {
                    anchor : '90%',
                    border : false
                },
        items:[{
            layout:'column',
            border: false,
            items:[{
                xtype: 'fieldset',
                title: '药房',
                labelAlign : 'right',
                style:'margin-right:10px;',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.45',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                        fieldLabel: '药物',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugmast1',
                        queryParam : 'drugdesc',
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        pageSize:ComboPage,
                        minChars: 0,  //查询条件为空值时,执行查询
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                            url:drugmast_ACTION_URL,
                            root: 'results',
                            queryParam:'drugdesc',
                            totalProperty: 'totalCount',
                            idProperty: 'rowid',
                            fields:['rowid','desc','drgform']
                      }) 
                },{
                        fieldLabel: '药物形态',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugform1',
                        mode:'local',
                        pageSize:ComboPage,
                        minChars: 0,   
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                             url:drugform_ACTION_URL,
                             root: 'results',
                             queryParam:'drugformselect',
                             totalProperty: 'totalCount',
                             idProperty: 'rowid',
                             fields:['rowid','desc']
                        }),
                        listeners:{
                            'beforequery':function(obj){
                                obj.combo.store.load({params:{
                                         start:0,
                                         limit:10,
                                         drugformrowid:Ext.getCmp("drugmast").getValue()
                                    }
                                });
                            return false;
                        }
                    }                    
                },{
                    fieldLabel: 'MIMS/FDB No',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Dose Calculation',
                    name: '',
                    disabled:true
                }]
            },{
                xtype: 'fieldset',
                title: 'Questionaire',
                labelWidth:100,
                labelAlign : 'right',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.55',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                    fieldLabel: 'Order Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Administration Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Result Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Phone Order Review Time (hours)',
                    disabled:true,
                    xtype:'textfield',
                    name: '',
                    id:'PhoneOrderReviewTime1'
                }]
            }]
        },{
            xtype:'fieldset',
            title:'其他',
            labelAlign : 'right',
            items:[{
                layout:'column',
                border: false,
                items: [{
                    layout: 'form',
                    columnWidth: '.5',
                    labelWidth:100,
                    defaults: {xtype:'textfield',anchor:'90%'},
                    items: [{
                                fieldLabel: '账单描述',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '二选一描述',
                                disabled:true
                            },{
                                fieldLabel: 'Consultation Department',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: 'Dental State',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '核实医嘱复制天数',
                                disabled:true
                            },{
                                fieldLabel: '模板',
                                disabled:true
                            },{
                                fieldLabel: 'Result Group',
                                disabled:true
                            },{
                                fieldLabel: 'Result Display Group',
                                xtype:'combo',
                                disabled:true
                        }]
                },{
                        columnWidth:'.5',
                        layout: 'form',
                        border:false,
                        labelAlign:'top',
                        style:'margin-left:20px',
                        defaults: {width:180,xtype: 'textarea',msgTarget:'qtip'},
                        items: [{
                            fieldLabel: 'Booking Notes',
                            disabled:true
                        },{
                            fieldLabel: 'Processing Notes',
                            disabled:true
                        }]
                }]
            }]
        }] 
    });
    */
    /////////////////////////////// 弹出窗口 其他明细 2  /////////////////////////////////////////
    var winformDetailOther2 = {
        xtype:"form",
        title:'关联零收费项',
        labelAlign : 'right',
        frame:true,
        items:[{
            xtype:'fieldset',
            anchor:'96%',
            title:'与零收费项目的关联<font color=red>（可选）</font>',
            items:{
                  layout: 'column',          
                  items:[{
                            columnWidth:'.4',
                            layout: 'form',             
                            defaults: {anchor:'90%'},
                            items: [{   
                                xtype:'checkbox',
                                boxLabel:'添加零收费项目关联',
                                id:'zerofee1',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('zerofee1'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('zerofee1')),
                                inputValue:'Y',
                                listeners:{
                                    'check' : function(com, checked){
                                        if(checked){
                                            enableZeroChargeForAdd()
                                            
                                        }else{
                                            disableZeroChargeForAdd()
                                            
                                        }
                                    }
                                }
                            },{
                                fieldLabel:'<font color=red>*</font>收费子分类',
                                xtype:'bdpcombo',
                                id:'chargesubcat1',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                                minChars: 0,   
                                listWidth:250,
                                valueField:'TARSCRowId',
                                displayField:'TARSCDesc',
                                store:new Ext.data.JsonStore({
                                    url:SubCate_ACTION_URL,
                                    root: 'data',
                                    totalProperty: 'total',
                                    idProperty: 'rowid',
                                    fields:['TARSCRowId','TARSCCode','TARSCDesc']
                                })                  
                            },{
                               fieldLabel:'<font color=red>*</font>核算子分类',
                               xtype:'combo',
                               id:'emcsubcat1',
                               triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               listWidth:250,
                               minChars: 0,   
                               valueField:'TARECRowId',
                               displayField:'TARECDesc',
                               store:new Ext.data.JsonStore({
                                     url:EMCCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARECRowId','TARECCode','TARECDesc']
                                })                                  
                            },{
                                fieldLabel:'<font color=red>*</font>会计子分类',
                                xtype:'combo',
                                id:'acctsubcat1',
                                triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               minChars: 0,   
                               listWidth:250,
                               valueField:'TARACRowId',
                               displayField:'TARACDesc',
                               store:new Ext.data.JsonStore({
                                 url:AcctCate_ACTION_URL,
                                 root: 'data',
                                 totalProperty: 'total',
                                 idProperty: 'rowid',
                                 fields:['TARACRowId','TARACCode','TARACDesc']
                               }) 
                            }]
                        },{
                            columnWidth:'.4',
                            layout: 'form',                 
                            labelWidth:120,
                            style:'margin-left:30px',
                            defaults: {anchor:'90%'},
                            items: [{
                                fieldLabel:'<font color=red>*</font>住院子分类',
                                xtype:'bdpcombo',
                                id:'inpatsubcat1',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo , 
                                minChars: 0,   
                                listWidth:250,
                                valueField:'TARICRowId',
                                displayField:'TARICDesc',
                                store:new Ext.data.JsonStore({
                                     url:InpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARICRowId','TARICCode','TARICDesc']
                               }) 
                        },{
                                fieldLabel:'<font color=red>*</font>门诊子分类',
                                xtype:'bdpcombo',
                                id:'outpatsubcat1',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                 pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                 minChars: 0,   
                                 listWidth:250,
                                 valueField:'TAROCRowId',
                                displayField:'TAROCDesc',
                                 store:new Ext.data.JsonStore({
                                     url:OutpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TAROCRowId','TAROCCode','TAROCDesc']
                               }) 
                            },{
                                fieldLabel:'<font color=red>*</font>病案首页子分类',
                                xtype:'bdpcombo',
                                id:'mrsubcat1',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,   
                                listWidth:250,
                                valueField:'TARMCRowId',
                                displayField:'TARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MRCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARMCRowId','TARMCCode','TARMCDesc']
                               }) 
                            },{
                                fieldLabel:'新病案首页子分类',
                                xtype:'bdpcombo',
                                id:'MCNew_com1',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,   
                                listWidth:250,
                                valueField:'NTARMCRowId',
                                displayField:'NTARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MCNew_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['NTARMCRowId','NTARMCDesc']
                               }) 
                            }]
                       }]
                    }
            },{
                xtype:'fieldset',
                title:'说明',
                anchor:'96%',
                autoHeight : true,
                //bodyStyle : 'margin-left:10px;',
                html : '<font color=blue>1、关联零收费项后，可在“医嘱项”标签页“医嘱项与收费项目关联明细”表格中查看。<br><br>'
                      +'2、关联了收费项的医嘱项不能再次关联零收费项。<br><br>'
                      +'3、新增的收费项目可在“收费项目维护”中查找，收费项目代码为该医嘱项代码。</font>'
            }]
    };
    
    //////////////////////////医嘱复制的输入面板/////////////////////////////////////////////////
           
   
    ////复制医嘱项
    var copyformDetail = new Ext.form.FormPanel({
        title:'基本信息',
        labelWidth: 100,
        frame:true,
        defaults: {anchor:'96%'},
        items:[{
            xtype:'fieldset',
            title:'医嘱项基本信息',
            labelWidth: 100,
            autoHeight:true,
            items :{
                layout:'column',
                border:false,
                items:[{
                    columnWidth:'.4',
                    layout: 'form',
                    labelWidth: 100,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [{
                        
                        
                        
                        fieldLabel: '<font color=red>*</font>医嘱代码',
                        dataIndex:'code',
                        id:'ordercode2',
                        allowBlank:false,
                        maxLength:100,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ordercode2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ordercode2')),
                        listeners :{
                            specialkey: function(field, e){                                 
                                if (e.getKey() == e.ENTER) {
                                    var searchstr=Ext.getCmp('ordercode2').getValue()
                                    var maxcode=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetMaxCode",searchstr,hospComp.getValue());
                                    Ext.getCmp('ordercode2').setValue(maxcode)
                                }
                            },
                            render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '回车查询最大码并自动加1'  
                                    })  
                                } 
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱名称',
                        id:'orderdesc2',
                        allowBlank:false,
                        
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderdesc2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderdesc2')),
                        listeners :{
                            'blur':function(f){
                                copywin.setTitle('添加新医嘱项'+ " -- " + f.getValue());
                                
                                
                                ///根据医嘱名称自动获取拼音首字母大写别名
                                var pinyins=Pinyin.GetJPU(Ext.getCmp("orderdesc2").getValue());
                                Ext.getCmp("orderaliasinput2").setValue(pinyins);
                                
                                
                            }
                        }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱大类',
                        xtype:'bdpcombo',
                        id:'OECOrderCatDR2',
                        allowBlank:false,
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OECOrderCatDR2')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'ORCATRowId',
                        displayField:'ORCATDesc',
                        store:new Ext.data.JsonStore({
                            url:OrderCatDR_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ORCATRowId','ORCATDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("arcitemcat2").setValue("");
                                    
                                    var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                                    if (flag==1)
                                    {
                                        var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR2").getValue()+"^"+Ext.getCmp("arcitemcat2").getValue()+"^1",hospComp.getValue());
                                        Ext.getCmp("ordercode2").setValue(MaxCode) 
                                    }
                                },
                                'beforequery': function(e){
                                    this.store.baseParams = {
                                            desc:e.query,
                                            hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                                                
                                 }
                            }
                    },{
                        fieldLabel: '<font color=red>*</font>医嘱子类',
                        xtype:'bdpcombo',
                        id:'arcitemcat2',
                        allowBlank:false,
                        
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('arcitemcat2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('arcitemcat2')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam : 'desc',
                        allQuery:'',  
                        pageSize:ComboPage,
                        minChars: 0,     
                        listWidth:250,
                        valueField:'ARCICRowId',
                        displayField:'ARCICDesc',
                        store:new Ext.data.JsonStore({
                                url:ItemCat_ACTION_URL,
                                root: 'data',
                                totalProperty: 'total',
                                idProperty: 'rowid',
                                fields:['ARCICRowId','ARCICCode','ARCICDesc']
                            }),
                        listeners:{
                                'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue(),
                                        ordcat:Ext.getCmp("OECOrderCatDR2").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                                                
                                 },
                                 'select': function(field,e){
                                    ///自动生成代码20170727
                                    var flag= tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetAutoCreateFlag",hospComp.getValue())
                                    if (flag==1)
                                    {
                                        var MaxCode = tkMakeServerCall("web.DHCBL.CT.ARCItmMast","AutoCreateCode",Ext.getCmp("OECOrderCatDR2").getValue()+"^"+Ext.getCmp("arcitemcat2").getValue()+"^1",hospComp.getValue());
                                        Ext.getCmp("ordercode2").setValue(MaxCode) 
                                    }
                                }
                        }
                    },{
                        fieldLabel: '医嘱优先级',  //<font color=red>*</font>
                        xtype:'bdpcombo',
                        id:'defaultpriority2',
                       //   allowBlank:false,
                        
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('defaultpriority2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('defaultpriority2')),
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        allQuery:'',   
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'OECPRRowId',
                        displayField:'OECPRDesc',
                        store:new Ext.data.JsonStore({
                            url:defaultpriority_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['OECPRRowId','OECPRCode','OECPRDesc']
                        }) 
                    },{
                        fieldLabel: '医嘱缩写',
                        id:'orderabbrev2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('orderabbrev2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderabbrev2'))
                    },{
                        xtype: 'datefield',
                        fieldLabel: '<font color=red>*</font>开始日期',
                        id:'fromdate2',
                        allowBlank:false,
                        
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('fromdate2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('fromdate2')),
                        name: 'DateFrom',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                            }
                        }
                    },{
                        xtype: 'datefield',
                        fieldLabel: '结束日期',
                        id:'todate2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('todate2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('todate2')),
                        name: 'DateTo',
                        format: BDPDateFormat,
                        enableKeyEvents : true,
                        listeners : { 
                            'keyup' : function(field, e){ 
                                Ext.BDP.FunLib.Component.GetCurrentDate(field,e); 
                            }
                        }
                    
                    }
                    
                    
                    ]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    labelWidth: 100,
                    labelPad:1,
                    labelAlign : 'right',
                    border:false,
                    defaults: {anchor:'90%',xtype: 'textfield',msgTarget:'qtip'},
                    items: [{
                            fieldLabel: '<font color=red>*</font>医嘱别名',
                            id:'orderaliasinput2',
                            allowBlank:false,
                            xtype: 'textfield',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('orderaliasinput2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderaliasinput2'))
                    },{
                        fieldLabel: '<font color=red>*</font>账单组',
                        xtype:'bdpcombo',
                        allowBlank:false,
                        
                        id:'billgroupother2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('billgroupother2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billgroupother2')),
                        allQuery:'',  
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCBGRowId',
                        displayField:'ARCBGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCBGRowId','ARCBGDesc']
                        }),
                        listeners:{
                            'select': function(field,e){
                                    Ext.getCmp("subbillgroupother2").setValue("");  //清空账单亚组的值
                                    
                                },
                             'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                            }                           
                    },{
                        fieldLabel: '<font color=red>*</font>账单子组',
                        xtype:'bdpcombo',
                        id:'subbillgroupother2',
                        allowBlank:false,
                        
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('subbillgroupother2')),
                        allQuery:'',  
                        forceSelection: true,
                        selectOnFocus:true,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,
                        listWidth:250,
                        valueField:'ARCSGRowId',
                        displayField:'ARCSGDesc',
                        store:new Ext.data.JsonStore({
                            url:BillSubGroup_ACTION_URL,
                            root: 'data',
                            totalProperty: 'total',
                            idProperty: 'rowid',
                            fields:['ARCSGRowId','ARCSGDesc']
                        }),
                        listeners:{
                             'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue(),
                                        ParRef:Ext.getCmp("billgroupother2").getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                         }                              
                    },{
                            fieldLabel:'费用标准',
                            id:'ARCIMDerFeeRulesDR2',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDerFeeRulesDR2'),
                            xtype:'bdpcombo',
                            triggerAction:'all', 
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,
                            listWidth:250,
                            valueField:'DFRRowId',
                            displayField:'DFRDesc',
                            store:new Ext.data.JsonStore({
                               url:ARCDerivedFeeRules_ACTION_URL,
                               root: 'data',
                               totalProperty: 'total',
                               idProperty: 'rowid',
                               fields:['DFRRowId','DFRDesc']
                            }) 
                    },{
                            fieldLabel: '账单单位',  //<font color=red>*</font>
                            xtype:'bdpcombo',
                            id:'billunit2',
                            //allowBlank:false,
                        
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('billunit2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billunit2')),
                            forceSelection: true,
                            selectOnFocus:false,
                            mode:'remote',
                            queryParam:'desc',
                            pageSize:ComboPage,
                            minChars: 0,   
                            listWidth:250,
                            valueField:'CTUOMRowId',
                            displayField:'CTUOMDesc',
                            store:new Ext.data.JsonStore({
                                url:BillUnit_ACTION_URL,
                                root:'data',
                                totalProperty:'total',
                                idProperty:'rowid',
                                fields:['CTUOMRowId','CTUOMDesc']
                            })   
                    },{
                            fieldLabel: '服务/材料',
                            xtype:'combo',
                            id:'material2',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('material2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('material2')),
                            valueField:'rowid',
                            displayField:'code',
                            mode:'local',
                            store: new Ext.data.ArrayStore({
                                fields: ['rowid','code'],
                                data: [['S','服务'],['M','材料']]
                            })
                    },{
                        fieldLabel: '服务组',
                        xtype:'bdpcombo',
                        id:'form_servicegroup2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('form_servicegroup2')),
                        allQuery:'',   
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        queryParam:'desc',
                        pageSize:ComboPage,
                        minChars: 0,   
                        listWidth:250,
                        valueField:'SGRowId',
                        displayField:'SGDesc',
                        store:new Ext.data.JsonStore({
                            url:resourcegroup_ACTION_URL,
                             root: 'data',
                             totalProperty: 'total',
                             idProperty: 'rowid',
                             fields:['SGRowId','SGDesc']
                        }),
                        listeners:{
                            'beforequery': function(e){
                                    this.store.baseParams = {
                                        desc:e.query,
                                        hospid:hospComp.getValue()
                                    };
                                    this.store.load({params : {
                                                start : 0,
                                                limit : ComboPage
                                    }})
                            
                             }
                            }   
                    }
                    
                    
                    ]
                },{
                    columnWidth:'.3',
                    layout: 'form',
                    border:false,
                    style:'margin-left:20px',  ////解决新框架第三列与第二列紧挨着的情况
                    labelAlign:'top',
                    defaults: {xtype: 'textarea',msgTarget:'qtip'},
                    items: [{
                            fieldLabel: '医嘱备注',
                            id:'orderadvice2',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('orderadvice2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('orderadvice2'))
                        },{
                        xtype:'checkboxgroup',
                        hideLabel:true,
                        anchor:'90%',
                        layout:'column',  //解决新框架checkbox标签显示换行的问题，直接分成三行显示
                        ///columns: [0.4, 0.6], 
                        items:[
                            {
                                columnWidth:'.99',
                                layout: 'form',
                                items: [
                                {
                            boxLabel:'独立医嘱',
                            id:'independentorder2',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('independentorder2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('independentorder2')),
                            inputValue:'Y'
                        },{
                            boxLabel:'无库存医嘱',
                            id:'nostock2',
                            readOnly:true,
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('nostock2')),
                            inputValue:'Y',
                            listeners:{
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '没有关联库存项的医嘱，只能是无库存医嘱'  
                                    })  
                                }  
                            }
                        },{
                            boxLabel:'加急医嘱',
                            id:'ARCIMSensitive2',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitive2')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        Ext.getCmp("ARCIMDefSensitive2").readOnly = false;
                                    }
                                    else
                                    {
                                        Ext.getCmp("ARCIMDefSensitive2").setValue(false)
                                        Ext.getCmp("ARCIMDefSensitive2").readOnly = true;
                                    }
                                }
                            }   
                        },{
                            boxLabel:'默认加急',
                            id:'ARCIMDefSensitive2',
                            readOnly:Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive2'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDefSensitive2')),
                            inputValue:'Y',
                            listeners:{
                                'check':function(e,checked)
                                {
                                    if(checked==true)
                                    {
                                        var ARCIMSensitive=Ext.getCmp("ARCIMSensitive2").getValue(); 
                                        if (ARCIMSensitive==false){   
                                            Ext.Msg.alert("提示","加急医嘱才能选择默认加急!"); 
                                            Ext.getCmp("ARCIMDefSensitive2").setValue(false);                                        
                                        }
                                    } 
                                 },
                                render : function(field) {  
                                    Ext.QuickTips.init();  
                                    Ext.QuickTips.register({  
                                        target : field.el,  
                                        text : '加急医嘱才能选择默认加急'  
                                    })  
                                }  
                            
                            }  
                        }]
                            }]
                    }]
                }]
            }
        
        },{
            xtype:'fieldset',
            title:'其他信息',
            autoHeight:true,
            labelAlign : 'right',
            items:[{
                layout:'column',
                border:false,
                
                items:[{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.4',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                           fieldLabel : 'Text1',
                           name : 'ARCIMText1',
                           id:'ARCIMText1Copy',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText1Copy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText1Copy'))
                    },{
                           fieldLabel : 'Text2',
                           name : 'ARCIMText2',
                           id:'ARCIMText2Copy',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText2Copy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText2Copy'))
                    },{
                           fieldLabel : 'Text3',
                           name : 'ARCIMText3',
                           id:'ARCIMText3Copy',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText3Copy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText3Copy'))
                    },{
                           fieldLabel : 'Text4',
                           name : 'ARCIMText4',
                           id:'ARCIMText4Copy',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText4Copy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText4Copy'))
                    },{
                           fieldLabel : 'Text5',
                           name : 'ARCIMText5',
                           id:'ARCIMText5Copy',
                           xtype: 'textfield',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMText5Copy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMText5Copy'))
                   
                    }]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [
                    {
                        fieldLabel: '单次最大剂量',
                        name:'ARCIMMaxCumDose2',
                        xtype:'textfield',
                        width:60,
                        id:'ARCIMMaxCumDose2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxCumDose2'))
                        
                    },{
                        fieldLabel: '每天最大剂量',
                        name:'ARCIMMaxQtyPerDay2',
                        xtype:'textfield',
                        width:60,
                        id:'ARCIMMaxQtyPerDay2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQtyPerDay2'))
                    },{
                        fieldLabel: '最大量',
                        name:'ARCIMMaxQty2',
                        width:45,
                        xtype:'textfield',
                        id:'ARCIMMaxQty2',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty2'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMMaxQty2'))
                     }
                    ]
                },{
                    layout: 'form',
                    labelWidth:100,
                    columnWidth: '.3',
                    
                    border:false,
                    defaults: {anchor:'90%'},
                    items: [{
                        fieldLabel: 'Patient OrderFile1',
                        id:'ARCIMPatientOrderFile12',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile12'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile12')),
                        name: 'ARCIMPatientOrderFile12'
                    },{
                        fieldLabel: 'Patient OrderFile2',
                        id:'ARCIMPatientOrderFile22',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile22'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile22')),
                        name: 'ARCIMPatientOrderFile22'
                    },{
                        fieldLabel: 'Patient OrderFile3',
                        id:'ARCIMPatientOrderFile32',
                        xtype: 'textfield',
                        readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile32'),
                        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMPatientOrderFile32')),
                        name: 'ARCIMPatientOrderFile32'
                    }]
                }]
            }]
        
        },{   
                xtype:'fieldset',
                title:'医嘱项其他选项',
                labelAlign : 'right',
                labelWidth:150,
                layout:'column',
                items:[{
                            columnWidth: '.3',
                            layout:'form',
                            border:false,
                            items:[
                    {
                           fieldLabel:'小时医嘱',
                           xtype : 'checkbox',
                           name:'ARCIMChgOrderPerHour',
                           id:'ARCIMChgOrderPerHourCopy',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMChgOrderPerHourCopy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMChgOrderPerHourCopy')),
                          inputValue : 'Y'
                     },{
                           fieldLabel:'使用ODBC模板',
                           name:'ARCIMUseODBCforWord',
                           id:'ARCIMUseODBCforWordCopy',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMUseODBCforWordCopy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMUseODBCforWordCopy')),
                           inputValue : 'Y'
                    },{
                           fieldLabel:'显示累计',
                           xtype : 'checkbox',
                           name:'ARCIMDisplayCumulative',
                           id:'ARCIMDisplayCumulativeCopy',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDisplayCumulativeCopy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDisplayCumulativeCopy')),
                           inputValue : 'Y'
                    },{
                           fieldLabel:'允许录入频次',
                           name:'ARCIMAllowInputFreq',
                           id:'ARCIMAllowInputFreqCopy',
                           xtype : 'checkbox',
                           readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowInputFreqCopy'),
                           style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMAllowInputFreqCopy')),
                           inputValue : 'Y'
                        }
                    
                        ]
                        },{
                            columnWidth: '.33',
                            border:false,
                            layout:'form',
                            items:[
                        {
                               fieldLabel:'限制为急诊病人用',
                               name:'ARCIMRestrictEM',
                               id:'ARCIMRestrictEMCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictEMCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictEMCopy')),
                              inputValue : 'Y'
                        },{
                               fieldLabel:'限制为住院病人用',
                               name:'ARCIMRestrictIP',
                               id:'ARCIMRestrictIPCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictIPCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictIPCopy')),
                               inputValue : 'Y'
                        },{
                               fieldLabel:'限制为门诊病人用',
                               name:'ARCIMRestrictOP',
                               id:'ARCIMRestrictOPCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictOPCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictOPCopy')),
                               inputValue : 'Y'
                        }
                        //ofy6
                        ,{
                               fieldLabel:'是否扫码计费',
                               name:'ARCIMScanCodeBilling',
                               //hidden:true,
                               //hideLabel : 'True',
                               id:'ARCIMScanCodeBillingCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMScanCodeBillingCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMScanCodeBillingCopy')),
                               inputValue : 'Y'
                        /*},{
                               fieldLabel:'检验条码双份打印',
                               name:'ARCIMDoublePrintFlag',
                               id:'ARCIMDoublePrintFlagCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDoublePrintFlagCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDoublePrintFlagCopy')),
                               inputValue : 'Y'
                               */
                            }
                        ]
                        },{
                            columnWidth: '.37',
                            border:false,
                            labelWidth:170,
                            layout:'form',
                            items:[
                        {
                               fieldLabel:'限制为体检病人用',
                               name:'ARCIMRestrictHP',
                               id:'ARCIMRestrictHPCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictHPCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMRestrictHPCopy')),
                               inputValue : 'Y'
                        },{
                               fieldLabel:'限制为已故病人用',
                               xtype : 'checkbox',
                               name:'ARCIMDeceasedPatientsOnly',
                               id:'ARCIMDeceasedPatientsOnlyCopy',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMDeceasedPatientsOnlyCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMDeceasedPatientsOnlyCopy')),
                               inputValue : 'Y'
                        },{
                               fieldLabel:'敏感医嘱',
                               name:'ARCIMSensitiveOrder',
                               id:'ARCIMSensitiveOrderCopy',
                               xtype : 'checkbox',
                               readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitiveOrderCopy'),
                               style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCIMSensitiveOrderCopy')),
                               inputValue : 'Y'
                        }]
                        }]
                    },{
                    xtype:'fieldset',
                    title:'关联收费项目<font color=red>[可选]</font>(开始日期在当天的00:00生效，结束日期在当天的24:00生效，请注意)',
                    autoHeight:true,
                    labelAlign : 'right',
                    items:[{
                        layout:'column',
                        border:false,
                        items:[{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.5',
                            border:false,
                            defaults: {anchor:'95%'},
                            items: [{
                                fieldLabel: '收费项目代码',
                                xtype:'textfield',              
                                id:'tarcode2',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarcode2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarcode2')),
                                xtype:'trigger',            
                                enableKeyEvents: true,
                                onTriggerClick:copygenLookup,
                                triggerClass:'x-form-search-trigger',
                                listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                 copygenLookup();
                                            }
                                        }
                                   }
                            },{
                                   xtype:'trigger',
                                   id: 'tarname2',
                                   readOnly:Ext.BDP.FunLib.Component.DisableFlag('tarname2'),
                                   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tarname2')),
                                   fieldLabel:'<font color=red>*</font>收费项目名称',
                                   enableKeyEvents: true,
                                   triggerClass:'x-form-search-trigger',
                                   onTriggerClick: copygenLookup,
                                   listeners: {
                                       specialkey: function(field, e){                                  
                                            if (e.getKey() == e.ENTER) {
                                                 copygenLookup();
                                            }
                                        }
                                   }
                              },{
                                fieldLabel: '结束日期',
                                xtype:'datefield',
                                id:'EffDateTo2',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDateTo2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDateTo2')),
                                name: 'EffDateTo',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
                            },{
                                xtype:'checkbox',
                                id:'copytarck2',
                                width:150,
                                boxLabel:'取消复制关联收费项',
                                listeners:{
                                    'check': function(com, checked){
                                        if(checked){
                                            ArrayTarCopy = []; //移除上次数据
                                            copyassociatestore.each(function(record){
                                                if(typeof(record.get('associaterowid'))!="undefined"){
                                                    ///2018-08-13 复制关联收费项时 开始日期为今天，结束日期为空
                                                    record.set('tarDate',TodayDate);    //开始日期
                                                    record.set('tarDateTo',""); //结束日期
                                                    ArrayTarCopy.push(record); //保留
                                                    copyassociatestore.remove(record);
                                                    copyOrderPriceTb.setText('');
                                                }
                                            });
                                        }else{
                                            for(var i=0;i<ArrayTarCopy.length;i++){
                                                copyassociatestore.add(ArrayTarCopy[i]);
                                                totalPrice=getOrderprice(copyassociatestore)
                                                copyOrderPriceTb.setText("收费项目合计金额为" +totalPrice+"元")
                                                
                                             }
                                        }
                                    }
                                }
                            }]
                        },{
                            layout: 'form',
                            labelWidth:100,
                            columnWidth: '.4',
                            border:false,
                            defaults: {anchor:'90%'},
                            items: [{
                                fieldLabel: '<font color=red>*</font>开始日期',
                                xtype:'datefield',
                                id:'EffDate2',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('EffDate2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EffDate2')),
                                name: 'EffDate',
                                format: BDPDateFormat,
                                enableKeyEvents : true,
                                listeners : { 
                                    'keyup' : function(field, e){ 
                                        Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
                                    }
                                }               
                            },{
                                fieldLabel: '<font color=red>*</font>数量',
                                id:'chargenum2',
                                readOnly:Ext.BDP.FunLib.Component.DisableFlag('chargenum2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('chargenum2')),
                                xtype:'numberfield',
                                decimalPrecision:6,
                                enableKeyEvents:true,
                                allowNegative : false,//不允许输入负数
                                allowDecimals : true,//允许输入小数
                                style:"ime-mode:disabled",   //不允许中文输入
                                listeners: {
                                    keydown:function(field, e){
                                         //数量文本框,只允许输入数字0-9或小数点、delete、backspace键
                                        if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==110)||(e.keyCode==190)||(e.keyCode==8)||(e.keyCode==46)) {}
                                        else {
                                            e.stopEvent()
                                        }
                                    }   
                                  }
                            }, {
                                fieldLabel: '基价模式',
                                xtype : 'checkbox',
                                id:'OLTBascPriceFlag2',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBascPriceFlag2')),
                                checked:true
                            }, {
                                fieldLabel: '多部位计价一次',
                                xtype : 'checkbox',
                                id:'OLTBillOnceFlag2',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OLTBillOnceFlag2')),
                                checked:true
                            }]
                        }]
                    }
                    ,
                        
                        {   
                    buttonAlign:'center',
                    buttons:[{
                                text:'添加收费项关联',
                                            iconCls : 'icon-add',
                                            id:'btn_AddOrderLinkTar2',
                                            disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_AddOrderLinkTar2'),
                                            handler:function(){
                                                AddCopyOrderLinkTar();
                                            }
                            },{
                                text:'修改收费项关联',
                                        iconCls : 'icon-update',
                                        id:'btn_UpdateOrderLinkTar2',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdateOrderLinkTar2'),
                                        handler:function(){
                                            UpdateCopyOrderLinkTar();
                                        }
                            },{
                                text:'重置收费项关联',
                                        iconCls : 'icon-refresh',
                                        id:'btn_tarclear2',
                                        handler:function()
                                        {
                                            resetOrderLinkPanelForCopy()
                                            
                                            
                                        }   
                                
                            },{
                                text:'删除收费项关联',
                                        iconCls : 'icon-delete',
                                        id:'DelOrderLinkTar_del_btn2',
                                        disabled : Ext.BDP.FunLib.Component.DisableFlag('DelOrderLinkTar_del_btn2'),
                                        handler:function()
                                        {
                                            DelCopyOrderLinkTar();
                                        }       
                            }]
                }
                    
                    
                    
                    
                    
                    
                    
                    ]
            },copyAssociateTaritem]
    });
    /*
    var copyformDetailOther1 = new Ext.form.FormPanel({
        title:'其他明细',
        frame:true,
        defaults : {
                    anchor : '90%',
                    border : false
                },
        items:[{
            layout:'column',
            border: false,
            items:[{
                xtype: 'fieldset',
                title: '药房',
                labelAlign : 'right',
                style:'margin-right:10px;',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.45',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                        fieldLabel: '药物',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugmast2',
                        queryParam : 'drugdesc',
                        forceSelection: true,
                        selectOnFocus:false,
                        mode:'remote',
                        pageSize:ComboPage,
                        minChars: 0,  
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                            url:drugmast_ACTION_URL,
                            root: 'results',
                            queryParam:'drugdesc',
                            totalProperty: 'totalCount',
                            idProperty: 'rowid',
                            fields:['rowid','desc','drgform']
                        })
                },{
                        fieldLabel: '药物形态',
                        xtype:'bdpcombo',
                        disabled:true,
                        id:'drugform2',
                        mode:'local',
                        pageSize:ComboPage,
                        minChars: 0,   
                        listWidth:250,
                        valueField:'rowid',
                        displayField:'desc',
                        store:new Ext.data.JsonStore({
                            url:drugform_ACTION_URL,
                            root: 'results',
                            queryParam:'drugformselect',
                            totalProperty: 'totalCount',
                            idProperty: 'rowid',
                            fields:['rowid','desc']
                        }),
                        listeners:{
                            'beforequery':function(obj){
                                obj.combo.store.load({
                                params:{
                                          start:0,
                                          limit:10,
                                          drugformrowid:Ext.getCmp("drugmast").getValue()
                                    }
                            });
                            return false;
                        }
                    }                    
                },{
                    fieldLabel: 'MIMS/FDB No',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Dose Calculation',
                    name: '',
                    disabled:true
                }]
            },{
                xtype: 'fieldset',
                title: 'Questionaire',
                labelWidth:100,
                labelAlign : 'right',
                bodyStyle:'padding-left:10px;padding-right:10px;',
                columnWidth: '.55',
                autoHeight: true,
                defaultType: 'combo',
                defaults: { anchor:'90%' },
                items: [{
                    fieldLabel: 'Order Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Administration Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Result Questionaire',
                    name: '',
                    disabled:true
                },{
                    fieldLabel: 'Phone Order Review Time (hours)',
                    disabled:true,
                    xtype:'textfield',
                    name: '',
                    id:'PhoneOrderReviewTime2'
                }]
            }]
        },{
            xtype:'fieldset',
            title:'其他',
            labelAlign : 'right',
            items:[{
                layout:'column',
                border: false,
                items: [{
                    layout: 'form',
                    columnWidth: '.5',
                    labelWidth:100,
                    defaults: {xtype:'textfield',anchor:'90%'},
                    items: [{
                                fieldLabel: '账单描述',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '二选一描述',
                                disabled:true
                            },{
                                fieldLabel: 'Consultation Department',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: 'Dental State',
                                xtype:'combo',
                                disabled:true
                            },{
                                fieldLabel: '核实医嘱复制天数',
                                disabled:true
                            },{
                                fieldLabel: '模板',
                                disabled:true
                            },{
                                fieldLabel: 'Result Group',
                                disabled:true
                            },{
                                fieldLabel: 'Result Display Group',
                                xtype:'combo',
                                disabled:true
                        }]
                },{
                        columnWidth:'.5',
                        layout: 'form',
                        border:false,
                        labelAlign:'top',
                        style:'margin-left:20px',
                        defaults: {width:180,xtype: 'textarea',msgTarget:'qtip'},
                        items: [{
                            fieldLabel: 'Booking Notes',
                            disabled:true
                        },{
                            fieldLabel: 'Processing Notes',
                            disabled:true
                        }]
                }]
            }]
        }]
    });
    */
    var copyformDetailOther2 = {
        xtype:"form",
        title:'关联零收费项',
        labelAlign : 'right',
        frame:true,
        items:[{
            xtype:'fieldset',
            title:'与零收费项目的关联<font color=red>（可选）</font>',
            anchor:'96%',
            items:{
                  layout: 'column',          
                  items:[{
                            columnWidth:'.4',
                            layout: 'form',             
                            defaults: {anchor:'90%'},
                            items: [{   
                                xtype:'checkbox',
                                boxLabel:'添加零收费项目关联',
                                id:'zerofee2',
                                readOnly : Ext.BDP.FunLib.Component.DisableFlag('zerofee2'),
                                style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('zerofee2')),
                                inputValue:'Y',
                                listeners:{
                                  'check' : function(com, checked){
                                        if(checked){
                                            enableZeroChargeForCopy()
                                        }else{
                                            disableZeroChargeForCopy()
                                        }
                                    }
                                }
                            },{
                                fieldLabel:'<font color=red>*</font>收费子分类',
                                xtype:'bdpcombo',
                                id:'chargesubcat2',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                                minChars: 0,   
                                listWidth:250,
                                valueField:'TARSCRowId',
                                displayField:'TARSCDesc',
                                store:new Ext.data.JsonStore({
                                    url:SubCate_ACTION_URL,
                                    root: 'data',
                                    totalProperty: 'total',
                                    idProperty: 'rowid',
                                    fields:['TARSCRowId','TARSCCode','TARSCDesc']
                                })              
                            },{
                               fieldLabel:'<font color=red>*</font>核算子分类',
                               xtype:'combo',
                               id:'emcsubcat2',
                               triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               listWidth:250,
                               minChars: 0,   
                               valueField:'TARECRowId',
                               displayField:'TARECDesc',
                               store:new Ext.data.JsonStore({
                                  url:EMCCate_ACTION_URL,
                                  root: 'data',
                                  totalProperty: 'total',
                                  idProperty: 'rowid',
                                  fields:['TARECRowId','TARECCode','TARECDesc']
                                })                              
                            },{
                                fieldLabel:'<font color=red>*</font>会计子分类',
                                xtype:'combo',
                                id:'acctsubcat2',
                                triggerAction:'all',
                               forceSelection: true,
                               selectOnFocus:false,
                               mode:'remote',
                               queryParam : 'desc',
                               pageSize :Ext.BDP.FunLib.PageSize.Combo  ,
                               minChars: 0,   
                               listWidth:250,
                               valueField:'TARACRowId',
                               displayField:'TARACDesc',
                               store:new Ext.data.JsonStore({
                                 url:AcctCate_ACTION_URL,
                                 root: 'data',
                                 totalProperty: 'total',
                                 idProperty: 'rowid',
                                 fields:['TARACRowId','TARACCode','TARACDesc']
                               })
                            }]
                        },{
                            columnWidth:'.4',
                            layout: 'form', 
                            style:'margin-left:30px',
                            labelWidth:120,
                            defaults: {anchor:'85%'},
                            items: [{
                                fieldLabel:'<font color=red>*</font>住院子分类',
                                xtype:'bdpcombo',
                                id:'inpatsubcat2',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo , 
                                minChars: 0,  
                                listWidth:250,
                                valueField:'TARICRowId',
                                displayField:'TARICDesc',
                                store:new Ext.data.JsonStore({
                                     url:InpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARICRowId','TARICCode','TARICDesc']
                               }) 
                        },{
                                fieldLabel:'<font color=red>*</font>门诊子分类',
                                xtype:'bdpcombo',
                                id:'outpatsubcat2',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,   
                                listWidth:250,
                                valueField:'TAROCRowId',
                                displayField:'TAROCDesc',
                                store:new Ext.data.JsonStore({
                                     url:OutpatCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TAROCRowId','TAROCCode','TAROCDesc']
                               }) 
                            },{
                                fieldLabel:'<font color=red>*</font>病案首页子分类',
                                xtype:'bdpcombo',
                                id:'mrsubcat2',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0,  
                                listWidth:250,
                                valueField:'TARMCRowId',
                                displayField:'TARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MRCate_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['TARMCRowId','TARMCCode','TARMCDesc']
                               }) 
                            },{
                                fieldLabel:'新病案首页子分类',
                                xtype:'bdpcombo',
                                id:'MCNew_com2',
                                triggerAction:'all',
                                forceSelection: true,
                                selectOnFocus:false,
                                mode:'remote',
                                queryParam : 'desc',
                                pageSize :Ext.BDP.FunLib.PageSize.Combo ,
                                minChars: 0, 
                                listWidth:250,
                                valueField:'NTARMCRowId',
                                displayField:'NTARMCDesc',
                                store:new Ext.data.JsonStore({
                                     url:MCNew_ACTION_URL,
                                     root: 'data',
                                     totalProperty: 'total',
                                     idProperty: 'rowid',
                                     fields:['NTARMCRowId','NTARMCDesc']
                               }) 
                            }]
                        }]
                    }
            },{
                xtype:'fieldset',
                title:'说明',
                anchor:'96%',
                autoHeight : true,
                //bodyStyle : 'margin-left:10px;',
                html : '<font color=blue>1、关联零收费项后，可在“医嘱项”标签页“医嘱项与收费项目关联明细”表格中查看。<br><br>'
                      +'2、关联了收费项的医嘱项不能再次关联零收费项。<br><br>'
                      +'3、新增的收费项目可在“收费项目维护”中查找，收费项目代码为该医嘱项代码。</font>'
            }]
    };
    
////////////////////////////// 弹窗 中的tab 页签///////////////////////////////////////////////////////    
    var copytabs=new Ext.TabPanel({
            id:'copytabs',
            region : 'center',
            //resizeTabs:true,  
            tabWidth:65,
            animScroll:true,
            enableTabScroll:true,
            //deferredRender :false,        //是否延迟渲染，缺省时为true，
            border:false,
            frame:true,
            activeTab:0,
            defaults:{autoScroll:true},
            items:[copyformDetail
            //copyformDetailOther1,
            //,copyformDetailOther2
            ]  
    });  
    
    /******************************************************************************************************/
    /************                   医嘱复制操作时弹出的窗口                                    ***********/
    /******************************************************************************************************/
    var height=Math.min(Ext.getBody().getHeight()-30,800)   
    var copywin = new Ext.Window({
            width : 900,  
            height : height,  
            minWidth:880,
            layout:'border',
            plain:true, 
            modal:true,
            frame:true,
            autoScroll: true,
            bodyStyle:'padding:1px',
            buttonAlign:'center',
            closeAction:'hide',
            items: [copytabs],
            buttons:[{
                text:'保存',
                iconCls : 'icon-save',
                id:'copybtn-save',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('copybtn-save'),
                handler:function(){
                    SaveForCopyARCIM();
                }
            },{
                text:'关闭',
                iconCls : 'icon-close',
                handler:function(){
                    copywin.hide();
                }
            }],
            listeners:{
                "beforehide":function(win){
                    //关联收费项表单
                    Ext.getCmp("tarcode2").enable();
                    Ext.getCmp("tarname2").enable();
                    Ext.getCmp("EffDate2").enable();
                    
                },
                "show":function(){
                    Ext.getCmp("copytarck2").enable();      //启用取消复制关联收费项checkbox
                    Ext.getCmp("copytarck2").setValue('0');   //清除取消复制关联收费项checkbox
                    Ext.getCmp('ordercode2').focus(true,800);
                    Ext.getCmp("copytarck2").enable();      //启用取消复制关联收费项checkbox
                    Ext.getCmp("copytarck2").setValue('0');   //清除取消复制关联收费项checkbox
                    Ext.getCmp("EffDate2").setValue(TodayDate);
                },
                "hide":function(){
                    OrderPriceTb.setText('');
                    comValue=0, PerPrice=0 ,totalPrice=0
                    //OrderAllergyStore.removeAll();
                },
                "close":function(){
                }
            }
        });
        
    
    ////////////////////////////////添加医嘱项弹窗：本地删除医嘱项与收费项目关联(以下)//////////////////////////////
                
    var DelOrderLinkTar = function(){
        var record = winAssociateTaritem.getSelectionModel().getSelections();
          if (record=="") {
             Ext.Msg.alert("提示","未选择收费项目关联,不能删除!");
             return;
          }else {
            
            associatestore.remove(record[0]);
            resetOrderLinkPanelForAdd()
          }
    }
    
/////////////////////////////// 医嘱复制弹窗：收费项删除操作///////////////////////////////////////////////////////
    
var DelCopyOrderLinkTar = function(){
    
        var record = copyAssociateTaritem.getSelectionModel().getSelections();
          if (record=="") {
             Ext.Msg.alert("提示","未选择收费项目关联,不能删除!");
             return;
          }else {
            copyassociatestore.remove(record[0]);
            
            
            resetOrderLinkPanelForCopy()
            
          }
    }
    
  /////////////////////////弹窗下的操作：本地  修改医嘱项与收费项目关联2012.07.16(以下)///////////////////////////////
  var UpdateOrderLinkTar= function(){
          var add_record = winAssociateTaritem.getSelectionModel().getSelections();
          if (add_record=="") {
             Ext.Msg.alert("提示","未选择收费项目关联,不能更新!");
             return;
          }else {
                if (Ext.getCmp("EffDate1").getValue()!="" & Ext.getCmp("EffDateTo1").getValue()!=""){
                        var fromdate=Ext.getCmp("EffDate1").getValue().format("Ymd");
                        var todate=Ext.getCmp("EffDateTo1").getValue().format("Ymd");
                        if (fromdate > todate) {
                            Ext.Msg.alert("提示","开始日期不能大于结束日期");
                            return;
                        }
                  }
                    var endDate =Ext.getCmp("EffDateTo1").getRawValue()
                     
                    add_record[0].set('tarDateTo',endDate);
                    add_record[0].set('tarnum', Ext.getCmp("chargenum1").getValue());
                    add_record[0].set('OLTBascPriceFlag', (Ext.getCmp("OLTBascPriceFlag1").getValue()==true)?'Y':'N');
                    add_record[0].set('OLTBillOnceFlag', (Ext.getCmp("OLTBillOnceFlag1").getValue()==true)?'Y':'N');
                     
                                                
                    resetOrderLinkPanelForAdd()
                    
            
             }
  }; 
  
  ///////////////////////////////////////医嘱复制 ：收费项修改维护 ////////////////////////////////
  
  var UpdateCopyOrderLinkTar= function(){
          var copyrecord =Ext.getCmp("copyAssociateTaritem").getSelectionModel().getSelections() ;
          if (copyrecord=="") {
             Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项收费项目关联!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             return;
          }else {
                if (Ext.getCmp("EffDate2").getValue()!="" & Ext.getCmp("EffDateTo2").getValue()!=""){
                        var fromdate=Ext.getCmp("EffDate2").getValue().format("Ymd");
                        var todate=Ext.getCmp("EffDateTo2").getValue().format("Ymd");
                        if (fromdate > todate) {
                            Ext.Msg.show({
                                    title:'提示',
                                    msg:"开始日期不能大于结束日期!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                            return;
                        }
                        
                        
                  }
                  
                  var endDate =Ext.getCmp("EffDateTo2").getRawValue()
                 var startDate=Ext.getCmp("EffDate2").getRawValue()
                    copyrecord[0].set('tarDateTo', endDate);
                    copyrecord[0].set('tarDate', startDate);
                    copyrecord[0].set('tarnum', Ext.getCmp("chargenum2").getValue());
                    copyrecord[0].set('OLTBascPriceFlag', (Ext.getCmp("OLTBascPriceFlag2").getValue()==true)?'Y':'N');
                    Ext.getCmp("OLTBascPriceFlag2").setValue(false);
                    copyrecord[0].set('OLTBillOnceFlag', (Ext.getCmp("OLTBillOnceFlag2").getValue()==true)?'Y':'N');
                    Ext.getCmp("OLTBillOnceFlag2").setValue(false);
                     
                    resetOrderLinkPanelForCopy()
                    
                    
                    
             }
  }; 
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////修改医嘱项与收费项目关联2012.07.16(以上)////////////////////////////////////////////////////
 
  /////////////////////////window 弹窗下的操作：添加医嘱项与收费项目关联,  前台操作/////////////////////////////
  var AddOrderLinkTar= function(){
        
         if (OltRowid!='') {
            Ext.Msg.show({
                            title:'提示',
                            msg:"选择某条关联收费项目后,只能修改或重置,不能做添加操作!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            return
         }  
         
          if (Ext.getCmp("chargenum1").getValue()==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"收费数量不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("chargenum1").focus();  
             return;
          }
          if (Ext.getCmp("EffDate1").getValue()==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"开始日期不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("EffDate1").focus();
             return;
          }
          if (Ext.getCmp("EffDate1").getValue()!="" & Ext.getCmp("EffDateTo1").getValue()!=""){
                var fromdate=Ext.getCmp("EffDate1").getValue().format("Ymd");
                var todate=Ext.getCmp("EffDateTo1").getValue().format("Ymd");
                if (fromdate > todate) {
                    Ext.Msg.show({
                                    title:'提示',
                                    msg:"开始日期不能大于结束日期!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                    return;
                }
          }
          var tarnametemp=tarInfo.split("^");                                
          if (tarnametemp[0]==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"收费项目不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("tarname1").focus();
             return;
          }else{
                    var flag = true;
                    var f=function(record){
                        if(tarnametemp[0]==record.get('olttariffdr')){
                            flag = false;
                        }
                    }
                    associatestore.each(f, this); //验证新增数据是否存在
                    if(flag){
                        var _record = new Ext.data.Record([
                                                        'arcimdr',
                                                        'olttariffdr',
                                                        'tarcode',
                                                        'tardesc',
                                                        'tarnum',
                                                        'taruom',
                                                        'tarDate',
                                                        'tarDateTo',
                                                        'OLTBascPriceFlag',
                                                        'OLTBillOnceFlag',
                                                        'tarprice',
                                                        'associaterowid'
                                                    ]);
                        _record.set('arcimdr',arcimrowid);          //医嘱项id
                        _record.set('olttariffdr',tarnametemp[0]);  //收费项目id
                        _record.set('tarcode',tarnametemp[1]);      //收费项目代码
                        _record.set('tardesc',tarnametemp[2]);      //收费项目描述
                        _record.set('tarprice',tarnametemp[3]);     //收费项目价格
                        _record.set('taruom',tarnametemp[4]);   
                        _record.set('tarnum',Ext.getCmp("chargenum1").getValue());  //数量
                        _record.set('OLTBascPriceFlag',(Ext.getCmp("OLTBascPriceFlag1").getValue()==true)?'Y':'N');
                        _record.set('OLTBillOnceFlag',(Ext.getCmp("OLTBillOnceFlag1").getValue()==true)?'Y':'N');
                        _record.set('tarDate',Ext.getCmp("EffDate1").getRawValue());    //开始日期
                        _record.set('tarDateTo',Ext.getCmp("EffDateTo1").getRawValue()); //结束日期
                        associatestore.add(_record);
                        
                        resetOrderLinkPanelForAdd()
                        
                    }else{
                        Ext.Msg.show({
                                        title:'提示',
                                        msg:"该记录已经存在!",
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                     });
                        }
                 }
    };  
  
  /////////////////////////////////医嘱复制操作  收费项 添加关联收费项////////////////////////////////////////
   
  var AddCopyOrderLinkTar= function(){
         if (OltRowid!='') {
                Ext.Msg.show({
                                title:'提示',
                                msg:"选择某条关联收费项目后,只能修改或重置,不能做添加操作!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                return
             }  
          if (Ext.getCmp("chargenum2").getValue()==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"收费数量不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("chargenum2").focus();   
             return;
          }
          if (Ext.getCmp("EffDate2").getValue()==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"开始日期不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("EffDate2").focus();
             return;
          }        
          if (Ext.getCmp("EffDate2").getValue()!="" & Ext.getCmp("EffDateTo2").getValue()!=""){
                var fromdate=Ext.getCmp("EffDate2").getValue().format("Ymd");
                var todate=Ext.getCmp("EffDateTo2").getValue().format("Ymd");
                if (fromdate > todate) {
                    Ext.Msg.show({
                                    title:'提示',
                                    msg:"开始日期不能大于结束日期!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                    return;
                }
          }
          var tarnametemp=tarInfo.split("^");                                
          if (tarnametemp[0]==''){
             Ext.Msg.show({
                            title:'提示',
                            msg:"收费项目不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                         });
             Ext.getCmp("tarname2").focus();
             return;
          }else{
                    var flag = true;
                    var f=function(record){
                        if(tarnametemp[0]==record.get('olttariffdr')){
                            flag = false;
                        }
                    }
                    copyassociatestore.each(f, this); //验证新增数据是否存在
                    if(flag){
                        var _record = new Ext.data.Record([
                                                        'arcimdr',
                                                        'olttariffdr',
                                                        'tarcode',
                                                        'tardesc',
                                                        'tarnum',
                                                        'taruom',
                                                        'tarDate',
                                                        'tarDateTo',
                                                        'OLTBascPriceFlag',
                                                        'OLTBillOnceFlag',
                                                        'tarprice',
                                                        'associaterowid'
                                                    ]);
                        _record.set('arcimdr',arcimrowid);          //医嘱项id
                        _record.set('olttariffdr',tarnametemp[0]);  //收费项目id
                        _record.set('tarcode',tarnametemp[1]);      //收费项目代码
                        _record.set('tardesc',tarnametemp[2]);      //收费项目描述
                        _record.set('tarprice',tarnametemp[3]);     //收费项目价格
                        _record.set('taruom',tarnametemp[4]);
                        _record.set('tarnum',Ext.getCmp("chargenum2").getValue());  //数量
                        _record.set('OLTBascPriceFlag',(Ext.getCmp("OLTBascPriceFlag2").getValue()==true)?'Y':'N');
                        _record.set('OLTBillOnceFlag',(Ext.getCmp("OLTBillOnceFlag2").getValue()==true)?'Y':'N');
                        _record.set('tarDate',Ext.getCmp("EffDate2").getRawValue());    //开始日期
                        _record.set('tarDateTo',Ext.getCmp("EffDateTo2").getRawValue()); //结束日期
                     
                        copyassociatestore.add(_record);
                        
                        
                        resetOrderLinkPanelForCopy()
                        
                        
                    }else{
                        Ext.Msg.show({
                                    title:'提示',
                                    msg:"该记录已经存在,请选择!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                    }
             }
  }; 

  //修改医嘱项与收费项目关联2012.07.16(以下)
  var UpdateOrderLinkTar_remote = function(){
            if (arcimrowid=='') {
                Ext.Msg.show({
                                title:'提示',
                                msg:"请先选择一条医嘱项!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                             });
                return;
            }
            //2022-09-13 【药品数据】不允许变动医嘱项与收费项关联关系
                /*var arcictype=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetTypeByARCIMRowId",arcimrowid);
                if ((arcictype=="R"))  //||(arcictype=="M")
                {
                     Ext.Msg.show({
                                    title:'提示',
                                    msg:'此界面不允许【药品数据】变动医嘱项与收费项关联关系，请核对数据!',  ///材料  
                                    minWidth:240,
                                    icon:Ext.Msg.WARNING,
                                    buttons:Ext.Msg.OK
                                });
                     return;
                }*/
            if (OltRowid=='') {
                Ext.Msg.show({
                                title:'提示',
                                msg:"未选择医嘱项收费项目关联!",
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                             });
                return;
            }
            
            
            
            var gsm = AssociateTaritem.getSelectionModel();// 获取选择列
            var rows = gsm.getSelections();// 根据选择列获取到所有的行
            
            
            
                //   1关联rowid ^2 医嘱项rowid arcimrowid ^ 3数量 ^ 4结束日期 ^  5OLTBascPriceFlag
                var UpdateOrdLinkTarStr=OltRowid+'^'+arcimrowid+'^'+Ext.getCmp('chargenum').getValue()+'^'+Ext.getCmp("EffDateTo").getRawValue()+'^'+Ext.getCmp('OLTBascPriceFlag').getValue()+'^'+Ext.getCmp('OLTBillOnceFlag').getValue()   
                    Ext.Ajax.request({
                        url:UpdateOrdLinkTar_ACTION_URL,
                        method:'POST',
                        params:{
                            'UpdateOrdLinkTarStr':UpdateOrdLinkTarStr
                            
                        },
                        callback:function(options, success, response){
                            if(success){
                                var jsonData = Ext.util.JSON.decode(response.responseText);
                                if(jsonData.success == 'true'){
                                        
                                            Ext.Msg.show({
                                                    title:'提示',
                                                    msg:'修改成功!',
                                                    icon:Ext.Msg.INFO,
                                                    buttons:Ext.Msg.OK,
                                                    fn:function(btn){
                                                    
                                                        resetOrderLinkPanelForUpdate()
                                                        RefreshOrderPrice()
                                                        }
                                                });
                                    
                                    
                                    
                                    }
                                    else{
                                        var errorMsg ='';
                                        if(jsonData.info){
                                            errorMsg='<br />'+jsonData.info
                                        }
                                    Ext.Msg.show({
                                                    title:'提示',
                                                    msg:errorMsg,
                                                    minWidth:210,
                                                    icon:Ext.Msg.ERROR,
                                                    buttons:Ext.Msg.OK
                                                });
                                        }
                                 }
                             }
                    })
                
                
             
  }; 
  //////////////////////修改医嘱项与收费项目关联2012.07.16(以上)////////////////////////////
  
 
  ////////////////////添加医嘱项与收费项目关联 以下  //////////////////////////////////////////
  var AddOrderLinkTar_remote = function(){
         if (OltRowid!='') {
            Ext.Msg.show({
                            title:'提示',
                            msg:"选择某条关联收费项目后,只能修改或重置,不能做添加操作!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            return
         }          
         if (arcimrowid=='') {
            Ext.Msg.show({
                            title:'提示',
                            msg:"请先选择一条医嘱项!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            return
         }
         //2022-09-13 【药品数据】不允许变动医嘱项与收费项关联关系
            var arcictype=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetTypeByARCIMRowId",arcimrowid);
            if ((arcictype=="R"))  //||(arcictype=="M")
            {
                 Ext.Msg.show({
                                title:'提示',
                                msg:'此界面不允许【药品数据】变动医嘱项与收费项关联关系，请核对数据!',  ///材料  
                                minWidth:240,
                                icon:Ext.Msg.WARNING,
                                buttons:Ext.Msg.OK
                            });
                 return;
            }
         if (Ext.getCmp("chargenum").getValue()=='') {
            Ext.Msg.show({
                            title:'提示',
                            msg:"收费数量不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            Ext.getCmp("chargenum").focus();   
            return
         }
         if (Ext.getCmp("EffDate").getValue()=='') {
            Ext.Msg.show({
                            title:'提示',
                            msg:"开始日期不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
            Ext.getCmp("EffDate").focus();
            return
         }
         if (Ext.getCmp("EffDate").getValue()!="" & Ext.getCmp("EffDateTo").getValue()!="") {
            var fromdate=Ext.getCmp("EffDate").getValue().format("Ymd");
            var todate=Ext.getCmp("EffDateTo").getValue().format("Ymd");
            if (fromdate > todate) {
                Ext.Msg.show({
                            title:'提示',
                            msg:"开始日期不能大于结束日期!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
                return;
            }
         }
         var tarnametemp=tarInfo.split("^");                                 
         if (tarnametemp[0]=='') {
             Ext.Msg.show({
                            title:'提示',
                            msg:"收费项目不能为空!",
                            icon:Ext.Msg.ERROR,
                            buttons:Ext.Msg.OK
                        });
             Ext.getCmp("tarname").focus();
             return
         }
         else {
            var tarnametemp=tarInfo.split("^");         
            AddOrdLinkTar="";
            AddOrdLinkTar=arcimrowid+"^"+tarnametemp[0]+"^"+Ext.getCmp("chargenum").getValue()+"^"+Ext.getCmp("EffDate").getRawValue()+"^"+Ext.getCmp("EffDateTo").getRawValue()+"^"+Ext.getCmp("OLTBascPriceFlag").getValue()+"^"+Ext.getCmp("OLTBillOnceFlag").getValue()    
            //Ext.MessageBox.wait('关联收费项目,正在添加中,请稍候...','提示');
            Ext.Ajax.request({
                url:AddOrdLinkTar_ACTION_URL,
                method:'POST',
                params:{
                    'addlinktar':AddOrdLinkTar   //添加收费项目关联串
                },
                callback:function(options, success, response){
                    if(success){
                        var jsonData = Ext.util.JSON.decode(response.responseText);
                        if(jsonData.success == 'true'){
                                
                                    
                            Ext.Msg.show({
                                    title:'提示',
                                    width:200,
                                    msg:'添加成功!',
                                    icon:Ext.Msg.INFO,
                                    buttons:Ext.Msg.OK,
                                    fn:function(btn){
                                                
                                                resetOrderLinkPanelForUpdate()
                                                RefreshOrderPrice()
                                            }
                                        });
                            
                        }
                        else{
                            var errorMsg ='';
                            if(jsonData.info){
                                errorMsg='<br/>'+jsonData.info
                            }
                            Ext.Msg.show({
                                            title:'提示',
                                            msg:errorMsg,
                                            minWidth:210,
                                            icon:Ext.Msg.ERROR,
                                            buttons:Ext.Msg.OK
                                        });
                                 }
                          }
                     }
                })
         }
    };  
    /////////////////////////////添加医嘱项与收费项目关联 (以上) ///////////////////////////////////////////

    
        ///////修改医嘱项时  国家/地区标准编码start 20160519
        
/// ////////////////////国家/地区标准编码页面 ////////////////////////////////////////////////////////////////////////
      var menuNameUpdate=""
      var CMBOXURLUpdate="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassQuery=GetDataForCmb1&menuName="+menuNameUpdate;
      var NationalCodeStoreUpdate=new Ext.data.Store({
            proxy : new Ext.data.HttpProxy({ url : CMBOXURLUpdate}),
            reader : new Ext.data.JsonReader({
            totalProperty : 'total',
            root : 'data',
            successProperty : 'success'
         }, [ 'BDPDomainRowId', 'BDPDomainExpression'])
      });
      
      Ext.BDP.FunLib.WinFormUpdate = new Ext.FormPanel({
                id : 'form-save2Update',
                labelAlign : 'right',
                split : true,
                frame : true,
                labelWidth:120,
                defaults : {
                    border : false   
                },
                title:'国家/地区标准编码',
                frame : true,       
                defaults : {
                    anchor : '90%',
                    border : false
                },
                items : [{
                            id:'BDPDomainRowIdUpdate',
                            xtype:'textfield',
                            fieldLabel : 'BDPDomainRowId',
                            name : 'BDPDomainRowId',
                            hideLabel : 'True',
                            hidden : true
                        }, {
                            xtype:'combo',
                            loadByIdParam:'rowid',
                            fieldLabel : '国家/地区标准编码名称',
                            name : 'BDPInternalDesc' ,
                            id:'BDPDomainDescFUpdate',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainDescFUpdate'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainDescFUpdate')),
                            store :NationalCodeStoreUpdate,
                            queryParam : 'desc',
                            triggerAction : 'all',
                            forceSelection : true,
                            selectOnFocus : false,
                            minChars : 0,
                            listWidth : 250,
                            valueField : 'BDPDomainRowId',
                            displayField : 'BDPDomainExpression',
                            hiddenName : 'BDPDomainDesc', 
                            pageSize :10,
                            enableKeyEvents : true,
                            listeners:{
                                'keyup':function(){ 
                                //alert(Ext.getCmp('BDPDomainDescFUpdate').getRawValue())
                                     if (Ext.getCmp('BDPDomainDescFUpdate').getRawValue()==""){
                                        Ext.getCmp('BDPStandardDomainDRFUpdate').setValue('')
                                     }
                                },
                                'beforequery':function(){
                                     menuNameUpdate=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","GetMenuName") ; 
                                     var CMBOXURLUpdate =  "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.BDPNationalDataDomain&pClassQuery=GetDataForCmb1&menuName="+menuNameUpdate  
                                     NationalCodeStoreUpdate.proxy = new Ext.data.HttpProxy({url:CMBOXURLUpdate}); 
                                },
                                'select':function(){
                                    var id=Ext.getCmp('BDPDomainDescFUpdate').getValue();
                                    var BDPStandardDomainDRValue=tkMakeServerCall("web.DHCBL.CT.BDPNationalDataDomain","FindDataValue",id); 
                                    var arr=new Array();
                                    var arr2=new Array();
                                    arr=BDPStandardDomainDRValue.split("^"); 
                                    arr2=arr[0].split("-"); 
                                    Ext.getCmp('BDPStandardDomainDRFUpdate').setValue(arr2[0]);
                                    Ext.getCmp('BDPStandardDomainValueFUpdate').setValue(arr2[1]);
                                    Ext.getCmp('BDPDomainDescFUpdate').setValue(arr[1]);  
                                }
                             } 
                        }, {
                            fieldLabel : '国家/地区标准编码',
                            xtype:'displayfield',
                            id:'BDPStandardDomainDRFUpdate',
                            name : 'BDPInternalCode',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDRFUpdate'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainDRFUpdate'))
                        }, {
                            fieldLabel:'国家/地区标准编码值',
                            xtype:'displayfield',
                            id:'BDPStandardDomainValueFUpdate',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainValueFUpdate'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPStandardDomainValueFUpdate')),
                            name : 'BDPStandardDomainValue'
                        }, {
                            fieldLabel : '医院标准编码',
                            xtype:'textfield',
                            id:'BDPDomainValueFUpdate',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueFUpdate'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueFUpdate')),
                            name : 'BDPHospNationalCode'
                        },{
                            fieldLabel : '医院标准编码名称',
                            xtype:'textfield',
                            id:'BDPDomainValueF1Update',
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF1Update'),
                            style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPDomainValueF1Update')),
                            name : 'BDPHospNationalDesc'
                        }]/*,
            buttonAlign:'center',
            buttons:[{
                text: '保存',
                width: 100,
                iconCls:'icon-save',
                id:'DetailForm2_update_btn3' ,
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DetailForm2_update_btn3'),
                handler:SaveForUpdateARCIM
            }]  */
                        
                        
    }); 
 
    /// 添加修改操作时的保存方法
    Ext.BDP.NationalCodeModFunUpdate=function(TableName,DataReference){  
        var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
        if (ShowOrNot=="Y"){
            var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);   
            if (flag==1){
                var InternalCode=Ext.getCmp('BDPStandardDomainDRFUpdate').getValue();  
                var InternalDesc=Ext.getCmp('BDPDomainDescFUpdate').getRawValue();   
                var HospNationalCode=Ext.getCmp('BDPDomainValueFUpdate').getValue();
                var HospNationalDesc=Ext.getCmp('BDPDomainValueF1Update').getValue();
                var InternalValue=Ext.getCmp('BDPStandardDomainValueFUpdate').getValue();
                var ID=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","GetRowIdByReference",TableName,DataReference) 
                if((InternalCode=="")&&(InternalDesc=="")&&(InternalValue=="")&&(HospNationalCode=="")&&(HospNationalDesc=="")&&(ID==""))
                {  
                    return false;
                }
                else
                { 
                var NationStr=InternalCode+"^"+InternalDesc+"^"+HospNationalCode+"^"+HospNationalDesc+"^"+TableName+"^"+DataReference+"^"+ID+"^"+InternalValue
                Ext.Ajax.request({
                        url : "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPStandardCode",
                        params : {listData : NationStr},
                        failure : function(result, request) {
                            Ext.Msg.show({
                                title:'提示',
                                minWidth:240,
                                msg:'请检查网络连接!',
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                        },
                        success : function(result, action) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if(jsonData.success=='true') {
                                
                            }else{
                                  Ext.Msg.show({
                                        title:'提示',
                                        minWidth:240,
                                        msg:"保存国家/地区标准编码失败!错误信息："+jsonData.errorinfo,
                                        icon:Ext.Msg.ERROR,
                                        buttons:Ext.Msg.OK
                                    });  
                                }
                            } 
                       });
                    }
                    }
                }
        }
        
//// 打开form时的加载数据
    Ext.BDP.OpenNationalCodeFunUpdate=function(TableName,DataReference){
        var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
        if (ShowOrNot=="Y"){
        var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);  
        if (flag==1)
        {
            var NationalStr=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","OpenData",TableName,DataReference)
            if (NationalStr!=null){
                var arr=new Array();
                arr=NationalStr.split("^"); 
                Ext.getCmp('BDPStandardDomainDRFUpdate').setValue(arr[0]); // 国家/地区编码
                Ext.getCmp('BDPDomainDescFUpdate').setValue(arr[1]); 
                Ext.getCmp('BDPDomainValueFUpdate').setValue(arr[2]); 
                Ext.getCmp('BDPDomainValueF1Update').setValue(arr[3]); 
            Ext.getCmp('BDPStandardDomainValueFUpdate').setValue(arr[4]); 
            }
          }
          else{
                return;
          }
        }
    }
    
//// 删除功能 
    Ext.BDP.DeleteFormFunUpdate=function(TableName,DataReference){
        var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
        if (ShowOrNot=="Y"){
            var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",TableName);   
            if (flag==1){
                Ext.Ajax.request({
                  url : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=DeleteNationalCode",
                  method : 'POST',
                  params : {
                        'tableName': TableName,
                        'dataReference':DataReference
                    },
                    callback : function(options, success, response) {
                     if (success) {
                        var jsonData = Ext.util.JSON.decode(response.responseText); 
                        if (jsonData.success == "false"){
                            Ext.Msg.alert("提示","删除标准数据编码失败!")
                        }
                    }
                }
            }); 
        }
    }
}

/// 整合tabpanel
     Ext.BDP.AddTabpanelFunUpdate=function(tabsUpdate,tableName){
        var ShowOrNot=tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IfOneKeyUp");   
        if (ShowOrNot=="Y"){
        var flag= tkMakeServerCall("web.DHCBL.BDP.BDPStandardCode","IsContrast",tableName);  
        if (flag==1){
         tabsUpdate.add(Ext.BDP.FunLib.WinFormUpdate);
         tabsUpdate.on('tabchange', function() {
                Ext.Ajax.request({  
                        url : "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPStandardCode&pClassMethod=SaveMenuName",
                        params : {menuName : tableName} 
                    });
             }); 
         }
    }
 }
 
    
 
 ///////修改医嘱项时  国家/地区标准编码end  20160519
    
 
 
    //////////////////////////  存放医嘱项修改时页面的各个标签   //////////////////////////////////////////////////
    var tabs = new Ext.TabPanel({
            id:'tabDetail',
            width:780,
            region : 'center',
            //resizeTabs:true,  True表示为自动调整各个标签页的宽度，以便适应当前TabPanel的候选栏的宽度，加了后收缩一次标签宽度会变小 
            tabWidth:60,
            //autoScroll:true,
            //animScroll:true,
            enableTabScroll:true,//有时标签页会超出TabPanel的整体宽度。为防止此情况下溢出的标签页不可见，就需要将此项设为true以出现标签页可滚动的功能。只当标签页位于上方的位置时有效（默认为false）。
            border:false,
            //deferredRender :false,        //是否延迟渲染，缺省时为true，
            frame:true,
            activeTab:0,
            defaults:{autoScroll:true},
            items:[formDetail
            //,formDetailOther1
            //,formDetailOther2
            ,ARCAliasJPanel,ARCExtCodeJPanel,ARCItmRecLocJPanel,AgeSexJPanel,HospitalJPanel   //,AllergyJPanel
            //,ARCLinkPanel   ///ofy7
            //,ARCLinkReagentPanel  ///ofy9
            //,ARCItemDependentPanel  ///ofy10
            //,ARCItemLocusPanel  ///ofy11
            
            ],
            buttonAlign:'center',
            buttons:[{
                text: '保存',
                width: 100,
                iconCls:'icon-save',
                id:'DetailForm_update_btn',
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DetailForm_update_btn'),  
                handler:SaveForUpdateARCIM
            }]
        });
        
    
        
    ///国家/地区标准编码 20160519
     Ext.BDP.AddTabpanelFunUpdate(tabs,Ext.BDP.FunLib.TableName);
     
     
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////医嘱添加时 弹窗 中的tab 页签///////////////////////////////////////////////////////
    var tabs2=new Ext.TabPanel({
            id:'tabs2',
            region : 'center',
            //resizeTabs:true,  
            tabWidth:65,
            animScroll:true,
            enableTabScroll:true,
            //deferredRender :false,        //是否延迟渲染，缺省时为true，
            border:false,
            frame:true,
            activeTab:0,
            defaults:{autoScroll:true},
            items:[winformDetail,
            //winformDetailOther1,
            //winformDetailOther2,
            ARCAliasJPanel2,winARCExtCodeJPanel,winARCItmRecLocJPanel,winAgeSexJPanel,winHospitalJPanel  //,winAllergyJPanel
            ]
    });  
    
    ///国家/地区标准编码 20160519
     Ext.BDP.AddTabpanelFun(tabs2,Ext.BDP.FunLib.TableName);
    /******************************************************************************************************/
    /************                   医嘱项添加时弹出的窗口                                        */
    /******************************************************************************************************/
    
    var win = new Ext.Window({
            width : 900,  
            height : height,  
            minWidth:880,
            layout:'border',
            plain:true, 
            modal:true,
            frame:true,
            autoScroll: true,
            bodyStyle:'padding:1px',
            buttonAlign:'center',
            closeAction:'hide',
            items: [tabs2],
            buttons:[{
                text:'保存',
                id:'btn-save',
                iconCls : 'icon-save',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btn-save'),
                handler:function(){
                    
                    AddOrder();
                }
            },{
                text:'关闭',
                iconCls : 'icon-close',
                handler:function(){
                    win.hide();
                }
            }],
            listeners:{
                "beforehide":function(win){
                    //关联收费项表单
                    Ext.getCmp("tarcode1").enable();
                    Ext.getCmp("tarname1").enable();
                    Ext.getCmp("EffDate1").enable();
                    Ext.getCmp("chargenum1").enable();
                
                },
                "show":function(){
                    Ext.getCmp('ordercode1').focus(true,800);
                    
                },
                "hide":function(){
                    OrderPriceTb.setText('');
                    comValue=0, PerPrice=0 ,totalPrice=0
                    //OrderAllergyStore.removeAll();
                    ///Referenceds.removeAll();
                    //Ext.getCmp("txtAllergenType1").reset();
                    //Ext.getCmp("txtAllergen1").reset();
                    
                    Ext.getCmp('winAgeSexPanel').getForm().reset();
                    Ext.getCmp('winAliasPanel').getForm().reset();
                    Ext.getCmp('winExtCodeform').getForm().reset();
                    Ext.getCmp('winHospitalPanel').getForm().reset();
                    Ext.getCmp('winRecLocForm').getForm().reset();
                },
                "close":function(){
                }
            }
        });
        
    /////////////////////////////// 选中行数据时显示医嘱项的信息  ///////////////////////////////////////
    btnTrans.on("click",function(){
            if (grid.selModel.hasSelection())
                {
                    var _record=grid.getSelectionModel().getSelected();
                    var selectrow=_record.get('ARCIMRowId');
                }
                else
                {
                    var selectrow=""
                }
                Ext.BDP.FunLib.SelectRowId=selectrow
        });
        
    ////2017-03-15 整理页面重复方法
        
    ///禁用添加医嘱页面的关联零收费项的form表单 disableZeroChargeForAdd()
    /*disableZeroChargeForAdd=function(){
        
        Ext.getCmp("chargesubcat1").setValue('');
        Ext.getCmp("chargesubcat1").disable();
        Ext.getCmp("emcsubcat1").setValue('');
        Ext.getCmp("emcsubcat1").disable();
        Ext.getCmp("acctsubcat1").setValue('');
        Ext.getCmp("acctsubcat1").disable();
        Ext.getCmp("inpatsubcat1").setValue('');
        Ext.getCmp("inpatsubcat1").disable();
        Ext.getCmp("outpatsubcat1").setValue('');                       
        Ext.getCmp("outpatsubcat1").disable();
        Ext.getCmp("mrsubcat1").setValue('');
        Ext.getCmp("mrsubcat1").disable();
        Ext.getCmp("MCNew_com1").setValue('');
        Ext.getCmp("MCNew_com1").disable();
        
    }
    
    ///启用添加医嘱页面的关联零收费项的form表单 disableZeroChargeForAdd()
    enableZeroChargeForAdd=function(){
        Ext.getCmp("chargesubcat1").enable();
        Ext.getCmp("emcsubcat1").enable();
        Ext.getCmp("acctsubcat1").enable();
        Ext.getCmp("inpatsubcat1").enable();
        Ext.getCmp("outpatsubcat1").enable();
        Ext.getCmp("mrsubcat1").enable();
        Ext.getCmp("MCNew_com1").enable();
    }
        
    ///禁用复制医嘱页面的关联零收费项的form表单 disableZeroChargeForCopy()
    disableZeroChargeForCopy=function(){
        
        Ext.getCmp("chargesubcat2").setValue('');
        Ext.getCmp("chargesubcat2").disable();
        Ext.getCmp("emcsubcat2").setValue('');
        Ext.getCmp("emcsubcat2").disable();
        Ext.getCmp("acctsubcat2").setValue('');
        Ext.getCmp("acctsubcat2").disable();
        Ext.getCmp("inpatsubcat2").setValue('');
        Ext.getCmp("inpatsubcat2").disable();
        Ext.getCmp("outpatsubcat2").setValue('');                       
        Ext.getCmp("outpatsubcat2").disable();
        Ext.getCmp("mrsubcat2").setValue('');
        Ext.getCmp("mrsubcat2").disable();
        Ext.getCmp("MCNew_com2").setValue('');
        Ext.getCmp("MCNew_com2").disable();
        
    }
    
    ///启用复制医嘱页面的关联零收费项的form表单 disableZeroChargeForCopy()
    enableZeroChargeForCopy=function(){
        Ext.getCmp("chargesubcat2").enable();
        Ext.getCmp("emcsubcat2").enable();
        Ext.getCmp("acctsubcat2").enable();
        Ext.getCmp("inpatsubcat2").enable();
        Ext.getCmp("outpatsubcat2").enable();
        Ext.getCmp("mrsubcat2").enable();
        Ext.getCmp("MCNew_com2").enable();
    }
    
    ///禁用修改医嘱页面的关联零收费项的form表单 disableZeroChargeForUpdate()
    disableZeroChargeForUpdate=function(){
        Ext.getCmp("chargesubcat").setValue('');
        Ext.getCmp("chargesubcat").disable();
        Ext.getCmp("emcsubcat").setValue('');
        Ext.getCmp("emcsubcat").disable();
        Ext.getCmp("acctsubcat").setValue('');
        Ext.getCmp("acctsubcat").disable();
        Ext.getCmp("inpatsubcat").setValue('');
        Ext.getCmp("inpatsubcat").disable();
        Ext.getCmp("outpatsubcat").setValue('');                        
        Ext.getCmp("outpatsubcat").disable();
        Ext.getCmp("mrsubcat").setValue('');
        Ext.getCmp("mrsubcat").disable();
        Ext.getCmp("MCNew_com").setValue('');
        Ext.getCmp("MCNew_com").disable();
        
    }
    
    ///启用修改医嘱页面的关联零收费项的form表单 disableZeroChargeForUpdate()
    enableZeroChargeForUpdate=function(){
        Ext.getCmp("chargesubcat").enable();
        Ext.getCmp("emcsubcat").enable();
        Ext.getCmp("acctsubcat").enable();
        Ext.getCmp("inpatsubcat").enable();
        Ext.getCmp("outpatsubcat").enable();
        Ext.getCmp("mrsubcat").enable();
        Ext.getCmp("MCNew_com").enable();
    }
    */
    ///重置医嘱页面的外部代码的form表单 resetExtcodePanelForAdd()
    resetExtcodePanelForAdd=function(){ 
        
        Ext.getCmp("externalcode1").reset();
        Ext.getCmp("externaldesc1").reset();                                                                    
        Ext.getCmp("reclocdesc1").reset();
        Ext.getCmp("externalDateFrom1").reset();
        Ext.getCmp("externalDateFrom1").setValue(TodayDate);
        Ext.getCmp("externalDateTo1").reset();
        Ext.getCmp("DefaultReceive1").reset();
        Ext.getCmp("defaultsend1").reset();
        RowId="";
        if (winOrderExtCodeList.selModel.hasSelection())
        {
            var linenum=winOrderExtCodeList.getSelectionModel().lastActive;   
            winOrderExtCodeList.getSelectionModel().deselectRow(linenum)
                                               
        }
                                            
    }   
    
    ///重置修改医嘱页面的外部代码的form表单 resetExtcodePanelForUpdate()
    resetExtcodePanelForUpdate=function(){  
        
        Ext.getCmp("externalcode").reset();
        Ext.getCmp("externaldesc").reset();                                                                 
        Ext.getCmp("reclocdesc").reset();
        Ext.getCmp("externalDateFrom").reset();
        Ext.getCmp("externalDateFrom").setValue(TodayDate);
        Ext.getCmp("externalDateTo").reset();
        Ext.getCmp("DefaultReceive").reset();
        Ext.getCmp("defaultsend").reset();
        RowId="";
        if (OrderExtCodeList.selModel.hasSelection())
        {
            var linenum=OrderExtCodeList.getSelectionModel().lastActive; 
            OrderExtCodeList.getSelectionModel().deselectRow(linenum)
                                               
        }
                                            
    }   
    
    
    ///重置添加医嘱页面的接收科室的form表单 resetPatLocPanelForAdd()
    resetPatLocPanelForAdd=function(){  
        
        Ext.getCmp("patloc1").reset();
        Ext.getCmp("recloc1").reset();                                                                  
        Ext.getCmp("defaultprior1").reset();
        Ext.getCmp("defaultflag1").setValue('0');
        Ext.getCmp("ARCRLCTHospitalDR1").setValue('');
        Ext.getCmp("RecLocDateFrom1").reset();
        Ext.getCmp("RecLocDateFrom1").setValue(TodayDate);
        Ext.getCmp("RecLocDateTo1").reset();
        Ext.getCmp("timefrom1").reset();
        Ext.getCmp("timeto1").reset();
        Ext.getCmp("ARCRLClinicType1").reset();

        RowId="";   
        if (winOrderRecLocList.selModel.hasSelection())
        {
            var linenum=winOrderRecLocList.getSelectionModel().lastActive;  //取消选择行
            winOrderRecLocList.getSelectionModel().deselectRow(linenum)
        }
                                            
    }   
    
    
    ///重置修改医嘱页面的接收科室的form表单 resetPatLocPanelForUpdate()
    resetPatLocPanelForUpdate=function(){   
        
        Ext.getCmp("patloc").reset();
        Ext.getCmp("recloc").reset();                                                                   
        Ext.getCmp("defaultprior").reset();
        Ext.getCmp("defaultflag").setValue('0');
        
        Ext.getCmp("ARCRLCTHospitalDR").setValue('');
        Ext.getCmp("RecLocDateFrom").reset();
        Ext.getCmp("RecLocDateFrom").setValue(TodayDate);
        Ext.getCmp("RecLocDateTo").reset();
        Ext.getCmp("timefrom").reset();
        Ext.getCmp("timeto").reset();
        Ext.getCmp("ARCRLClinicTypeF").reset();

        RowId="";
        if (OrderRecLocList.selModel.hasSelection())
        {
            var linenum=OrderRecLocList.getSelectionModel().lastActive;  //取消选择行
            OrderRecLocList.getSelectionModel().deselectRow(linenum)
        } 
        OrderRecLocDS.load({ 
        params:{start : 0, limit : pagesize_main, ParRef:arcimrowid},
        callback: function(r, options, success){
            if(success){
            }
            else{
                 Ext.Msg.show({
                                title:'提示',
                                msg:jsonData.info,
                                icon:Ext.Msg.ERROR,
                                buttons:Ext.Msg.OK
                            });
                }
             }
        });                                       
    }   
    
    ///重置修改医嘱页面的关联收费项的form表单 resetOrderLinkPanelForUpdate()
    resetOrderLinkPanelForUpdate=function(){
        Ext.getCmp("tarcode").setValue('');
        Ext.getCmp("tarname").setValue('');
        Ext.getCmp("chargenum").setValue('');
        Ext.getCmp("OLTBascPriceFlag").setValue(false);
        Ext.getCmp("OLTBillOnceFlag").setValue(false);  
        Ext.getCmp("tarcode").enable();
        Ext.getCmp("tarname").enable();
        Ext.getCmp("EffDate").enable();
        Ext.getCmp("chargenum").enable();
        ///2016-5-17  关联收费项 开始日期默认为当天
        Ext.getCmp("EffDate").setValue(TodayDate);
        Ext.getCmp("EffDateTo").setValue('');
        OltRowid="";  //清空选择的关联收费项目Rowid
        tarInfo=""; 
        comValue=0, PerPrice=0 ,totalPrice=0;
        
        
        //数据保存成功后,重新加载医嘱与收费项目的关联明细
        updateassociatestore.load({ 
            params: {
              arcimrowid:arcimrowid,
              hospid:hospComp.getValue()
            }, 
            callback: function(r, options, success){
                if(success){
                    
                }
                else{
                    Ext.Msg.show({
                                    title:'提示',
                                    msg:"医嘱与收费项目关联明细加载失败!",
                                    icon:Ext.Msg.ERROR,
                                    buttons:Ext.Msg.OK
                                 });
                }
             }
            }); 
            
        
    }
    //2021-05-20  将刷新价格的方法单独摘出来
    RefreshOrderPrice=function()
    {
        ///添加完关联收费项后刷新合计金额
        var price=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetOrderPrice",arcimrowid,hospComp.getValue());                       
        OrderPriceTb.setText("收费项目合计金额为" +price+"元");
        
        if (AssociateTaritem.selModel.hasSelection())
        {
            var linenum=AssociateTaritem.getSelectionModel().lastActive;  //取消选择行
            AssociateTaritem.getSelectionModel().deselectRow(linenum);
        }
        
        if (Ext.getCmp("grid").selModel.hasSelection())
        {
            if (grid.getSelectionModel().getSelected().data['orderprice']!=price)
            {
                var nub = Ext.getCmp("grid").getSelectionModel().lastActive;
                Ext.getCmp("grid").getStore().getAt(nub).set("orderprice",price);
            }
        }
    }
    ///重置增加医嘱页面的关联收费项的form表单 resetOrderLinkPanelForAdd()
    resetOrderLinkPanelForAdd=function(){
        Ext.getCmp("tarcode1").enable();
        Ext.getCmp("tarname1").enable();
        Ext.getCmp("EffDate1").enable();
        Ext.getCmp("EffDateTo1").enable();
        Ext.getCmp("tarcode1").setValue('');
        Ext.getCmp("tarname1").setValue('');
        Ext.getCmp("chargenum1").setValue('');
        Ext.getCmp("OLTBascPriceFlag1").setValue(false);
        Ext.getCmp("OLTBillOnceFlag1").setValue(false);
        Ext.getCmp("EffDate1").setValue(TodayDate);
        Ext.getCmp("EffDateTo1").setValue(''); 
        OltRowid="";  //清空选择的关联收费项目Rowid
        tarInfo=""; 
        comValue=0, PerPrice=0 ,totalPrice=0;
        
        /// 显示总价
        PriceCount=getOrderprice(associatestore)
        if (PriceCount!=0){
            winOrderPriceTb.setText("收费项目合计金额为" +PriceCount+"元")    
        }
        else
        {
            winOrderPriceTb.setText('收费项目合计金额为0元'); 
        }
        
        if (winAssociateTaritem.selModel.hasSelection())
        {
            var linenum=winAssociateTaritem.getSelectionModel().lastActive;  //取消选择行
            winAssociateTaritem.getSelectionModel().deselectRow(linenum);
        }
        
    
    }
    ///重置复制医嘱页面的关联收费项的form表单 resetOrderLinkPanelForCopy()
    resetOrderLinkPanelForCopy=function(){  
        Ext.getCmp("tarcode2").enable();
        Ext.getCmp("tarname2").enable();
        Ext.getCmp("chargenum2").enable();
        Ext.getCmp("tarcode2").setValue('');
        Ext.getCmp("tarname2").setValue('');
        Ext.getCmp("chargenum2").setValue('');
        Ext.getCmp("OLTBascPriceFlag2").setValue(false);
        Ext.getCmp("OLTBillOnceFlag2").setValue(false);
        Ext.getCmp("EffDate2").setValue(TodayDate);
        Ext.getCmp("EffDateTo2").setValue('');
        OltRowid="";  //清空选择的关联收费项目Rowid
        tarInfo=""; 
        comValue=0, PerPrice=0,totalPrice=0;
        /// 显示总价
        PriceCount=getOrderprice(copyassociatestore)
        if (PriceCount!=0){
            copyOrderPriceTb.setText("收费项目合计金额为" +PriceCount+"元")
        }  
        else{
            copyOrderPriceTb.setText("收费项目合计金额为0元")
        }
        if (copyAssociateTaritem.selModel.hasSelection())
        {
            var linenum=copyAssociateTaritem.getSelectionModel().lastActive;  //取消选择行
            copyAssociateTaritem.getSelectionModel().deselectRow(linenum);
        }
                                            
    }           
        
    //修改医嘱项面板里，  清空表单并重新加载医嘱项过敏原数据 resetAllergyForUpdate()  2017-03-15
    /*resetAllergyForUpdate=function()
    {
        Ext.getCmp("txtAllergenType").reset();
        Ext.getCmp("txtAllergen").reset();
        
        Referenceds.baseParams = {
            MRCATRowId : ""
        };
        
        OrderAllergyStore.load({
                    params : {
                        start : 0,
                        limit : pagesize_pop,
                        ParRef : arcimrowid
                    } 
                });
        
        RowId = "";
        if (OrderAllergyList.selModel.hasSelection())
        {
            var linenum = OrderAllergyList.getSelectionModel().lastActive; // 取消选择行
            OrderAllergyList.getSelectionModel().deselectRow(linenum)   
        }
        
    }
    
    
    
    
    //添加医嘱项面板里，  清空表单并重新加载医嘱项过敏原数据 resetAllergyForAdd()  2017-03-15
    resetAllergyForAdd=function()
    {
    
        Referenceds.baseParams = {
                    MRCATRowId : ""
                };
                
        winOrderAllergyStore.load({
            params : {
                        start : 0,
                        limit : pagesize_pop,
                        ParRef : arcimrowid
                    } 
                });
        Ext.getCmp("txtAllergenType1").reset();
        Ext.getCmp("txtAllergen1").reset();
        RowId = "";
        if (winOrderAllergyList.selModel.hasSelection())
        {
            var linenum = winOrderAllergyList.getSelectionModel().lastActive; // 取消选择行
            winOrderAllergyList.getSelectionModel().deselectRow(linenum)
        }
    
    }
    */
    selectMast=function() {
                
                if ((Ext.getCmp('grideast').collapsed))
                {
                    Ext.getCmp('formsearch').collapse();
                    Ext.getCmp('grideast').expand();
                }
                if ((Ext.getCmp('grideast').collapsed))
                {
                    Ext.getCmp('formsearch').collapse();
                    Ext.getCmp('grideast').expand();
                }
                //  w.collapsed ? w.expand() : w.collapse();  
                //Ext.getCmp("zerofee").setValue('0');  //清空是否零收费项checkbox

                var record = grid.getSelectionModel().getSelected(); 
                arcimrowid=record.data['ARCIMRowId'];
                
                ///医嘱大类
                Ext.getCmp('OECOrderCatDR').store.baseParams = {hospid:hospComp.getValue()};
                Ext.getCmp("OECOrderCatDR").store.load({
                        params: {rowid:record.data['OECOrderCatDR']}, 
                        callback: function(records, options, success){
                            Ext.getCmp("OECOrderCatDR").setValue(record.data['OECOrderCatDR']);
                            Ext.getCmp("OECOrderCatDR").setRawValue(record.data['OECOrderCatDRDesc']);
                            ///医嘱子类
                            Ext.getCmp("arcitemcat").store.load({
                                    params: {rowid:record.data['ARCIMItemCatDR']}, 
                                    callback: function(records, options, success){
                                        Ext.getCmp("arcitemcat").setValue(record.data['ARCIMItemCatDR']);
                                        Ext.getCmp("arcitemcat").setRawValue(record.data['ARCIMItemCatDRDesc']);
                                    }
                            });
                        }
                });
                //加载医嘱大类ComBox数据值
                //loadParams(grid,"OECOrderCatDR","OECOrderCatDR","OECOrderCatDRDesc");
                
                //加载医嘱子类ComBox数据值
                //loadParams(grid,"arcitemcat","ARCIMItemCatDR","ARCIMItemCatDRDesc");
                
                
                //加载医嘱默认优先级ComBox数据值
                loadParams(grid,"defaultpriority","ARCIMDefPriorityDR","ARCIMDefPriorityDRDesc");
                
                
                //服务组
                Ext.getCmp('form_servicegroup').store.baseParams = {hospid:hospComp.getValue()};
                Ext.getCmp("form_servicegroup").store.load({
                        params: {rowid:record.data['ARCIMServiceGroupDR']}, 
                        callback: function(records, options, success){
                            Ext.getCmp("form_servicegroup").setValue(record.data['ARCIMServiceGroupDR']);
                            Ext.getCmp("form_servicegroup").setRawValue(record.data['ARCIMServiceGroupDRDesc']);
                        }
                }); 
                //加载服务组ComBox数据值
                //loadParams(grid,"form_servicegroup","ARCIMServiceGroupDR","ARCIMServiceGroupDRDesc");
                ///账单组
                Ext.getCmp('billgroupother').store.baseParams = {hospid:hospComp.getValue()};
                Ext.getCmp("billgroupother").store.load({
                        params: {rowid:record.data['ARCIMBillGrpRowId']}, 
                        callback: function(records, options, success){
                            Ext.getCmp("billgroupother").setValue(record.data['ARCIMBillGrpRowId']);
                            Ext.getCmp("billgroupother").setRawValue(record.data['ARCIMBillGrpDesc']);
                            ///账单子组
                            Ext.getCmp("subbillgroupother").store.load({
                                    params: {rowid:record.data['ARCIMBillSubDR']}, 
                                    callback: function(records, options, success){
                                        Ext.getCmp("subbillgroupother").setValue(record.data['ARCIMBillSubDR']);
                                        Ext.getCmp("subbillgroupother").setRawValue(record.data['ARCIMBillSubDRDesc']);
                                    }
                            });
                        }
                });         
                //加载账单组ComBox数据值        
                //loadParams(grid,"billgroupother","ARCIMBillGrpRowId","ARCIMBillGrpDesc");
                            
                //加载账单子组ComBox数据值   
                //loadParams(grid,"subbillgroupother","ARCIMBillSubDR","ARCIMBillSubDRDesc");
                        
                //加载费用标准ComBox数据值
                loadParams(grid,"ARCIMDerFeeRulesDR","ARCIMDerFeeRulesDR","ARCIMDerFeeRulesDRDesc");
                             
                //加载账单单位ComBox数据值
                loadParams(grid,"billunit","ARCIMBillingUOMDR","ARCIMBillingUOMDRDesc");
            
                Ext.getCmp("ordercode").setValue(record.data['ARCIMCode']);    
                Ext.getCmp("orderdesc").setValue(record.data['ARCIMDesc']);
                Ext.getCmp("orderabbrev").setValue(record.data['ARCIMAbbrev']); 
                
                //alert(record.data['ARCIMEffDate'])
                Ext.getCmp("fromdate").setValue(record.data['ARCIMEffDate']);  
                Ext.getCmp("todate").setValue(record.data['ARCIMEffDateTo']);
                Ext.getCmp("orderadvice").setValue(record.data['ARCIMOEMessage']);
                Ext.getCmp("material").setValue(record.data['ARCIMServMaterial']);
                
                
                Ext.getCmp("nostock").readOnly = Ext.BDP.FunLib.Component.DisableFlag('nostock');
                
                if (record.data['ARCIMAllowOrderWOStockCheck']=='Y') {
                    Ext.getCmp("nostock").setValue("1")
                    ///2016-5-11 chenying
                    var linkedflag=tkMakeServerCall("web.DHCBL.CT.ARCItmMast","GetLinkedINCRowId",arcimrowid);
                    /// Y  被库存项关联了，  可以是无库存 也可以是 有库存  ； N时  必须是无库存医嘱
                    if (linkedflag=="N") 
                    {
                        Ext.getCmp("nostock").readOnly = true;
                        //alert(Ext.getCmp("nostock").readOnly+"readONly  linkedflagnn" )
                    }
                }else {
                    Ext.getCmp("nostock").setValue("0")
                }
                
                
                Ext.getCmp('independentorder').setValue(record.get('ARCIMOrderOnItsOwn')=='Y'?true:false);
                Ext.getCmp('ARCIMSensitive').setValue(record.get('ARCIMSensitive')=='Y'?true:false);
                Ext.getCmp('ARCIMDefSensitive').setValue(record.get('ARCIMDefSensitive')=='Y'?true:false);
                Ext.getCmp('ARCIMChgOrderPerHourF').setValue(record.get('ARCIMChgOrderPerHour')=='Y'?true:false);
                Ext.getCmp('ARCIMDeceasedPatientsOnlyF').setValue(record.get('ARCIMDeceasedPatientsOnly')=='Y'?true:false);
                Ext.getCmp('ARCIMDisplayCumulativeF').setValue((record.get('ARCIMDisplayCumulative'))=='Y'?true:false);
                Ext.getCmp('ARCIMAllowInputFreqF').setValue((record.get('ARCIMAllowInputFreq'))=='Y'?true:false);
                Ext.getCmp('ARCIMUseODBCforWordF').setValue((record.get('ARCIMUseODBCforWord'))=='Y'?true:false);
                Ext.getCmp('ARCIMRestrictEMF').setValue((record.get('ARCIMRestrictEM'))=='Y'?true:false);
                Ext.getCmp('ARCIMRestrictIPF').setValue((record.get('ARCIMRestrictIP'))=='Y'?true:false);           
                Ext.getCmp('ARCIMRestrictOPF').setValue((record.get('ARCIMRestrictOP'))=='Y'?true:false);
                Ext.getCmp('ARCIMRestrictHPF').setValue((record.get('ARCIMRestrictHP'))=='Y'?true:false);
                
                //ofy6 
			 	Ext.getCmp('ARCIMScanCodeBillingF').setValue((record.get('ARCIMScanCodeBilling'))=='Y'?true:false);
                Ext.getCmp('ARCIMSensitiveOrderF').setValue((record.get('ARCIMSensitiveOrder'))=='Y'?true:false);
                //Ext.getCmp('ARCIMDoublePrintFlagF').setValue((record.get('ARCIMDoublePrintFlag'))=='Y'?true:false);
                Ext.getCmp('ARCIMScanCodeBillingF').setValue((record.get('ARCIMScanCodeBilling'))=='Y'?true:false);
                
                Ext.getCmp("ARCIMText1F").setValue(record.data['ARCIMText1']);
                Ext.getCmp("ARCIMText2F").setValue(record.data['ARCIMText2']);      
                Ext.getCmp("ARCIMText3F").setValue(record.data['ARCIMText3']);    
                Ext.getCmp("ARCIMText4F").setValue(record.data['ARCIMText4']);
                Ext.getCmp("ARCIMText5F").setValue(record.data['ARCIMText5']);
                Ext.getCmp("ARCIMPatientOrderFile1").setValue(record.data['ARCIMPatientOrderFile1']);
                Ext.getCmp("ARCIMPatientOrderFile2").setValue(record.data['ARCIMPatientOrderFile2']);
                Ext.getCmp("ARCIMPatientOrderFile3").setValue(record.data['ARCIMPatientOrderFile3']);
                
                Ext.getCmp("ARCIMMaxCumDose").setValue(record.data['ARCIMMaxCumDose']);
                Ext.getCmp("ARCIMMaxQtyPerDay").setValue(record.data['ARCIMMaxQtyPerDay']);
                Ext.getCmp("ARCIMMaxQty").setValue(record.data['ARCIMMaxQty']);
                OrderHospStore.load({ params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});     
                OrderAliasStore.load({ params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                OrderAgeSexds.load({ params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}    });
                //OrderAllergyStore.load({params:{start:0,limit:pagesize_pop,ParRef: arcimrowid}});
                OrderExtCode.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                OrderRecLocDS.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                
                
                ///ofy7 ARCLinkds.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                ///ofy7 ResertLAPanel()
                
                ///ofy9  
                //ARCLinkReagentds.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                //resetALRPanel() 
                ///ofy10 
                //ARCItemDependentds.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                //resetDEPPanel() 
            
                ///ofy11
                //ARCItemLocusds.load({params:{start : 0, limit : pagesize_pop,ParRef: arcimrowid}});
                //resetLOCUSPanel() 
                
                
                //resetAllergyForUpdate();
                //disableZeroChargeForUpdate(); ///零收费项
                resetOrderLinkPanelForUpdate();             
                
                ///清空修改面板里的接收科室数据 2017-03-02
                resetPatLocPanelForUpdate();
                
                ///清空修改面板里的外部代码数据 2017-03-15
                resetExtcodePanelForUpdate();

                Ext.getCmp("sexdr").reset();
                Ext.getCmp("agefrom").reset();                                                                  
                Ext.getCmp("ageto").reset();
                Ext.getCmp("agefromtype").reset();                                                                  
                Ext.getCmp("agetotype").reset();

                Ext.getCmp("txtHospital").reset();
                Ext.getCmp("txtorderalias").reset();
                Ext.getCmp("AliasDateFrom").reset();                                                                    
                Ext.getCmp("AliasDateTo").reset();

                ////国家/地区标准编码 20160519
                Ext.BDP.OpenNationalCodeFunUpdate(Ext.BDP.FunLib.TableName,arcimrowid);
             }; 
         grid.on("rowclick", function(grid, rowIndex, e) {
              selectMast();
             });
     
             
                     
    /////////////////////西侧区域布局 //////////////////////////////////////////////////////////////
             
    var FormSearch=new Ext.Panel({
        id:'formsearch',
        region:'west',
        width:230,
        title:'医嘱项搜索',
        collapsed:false,
        iconCls:'icon-find',
        collapsible:true,
        split:true,//可调宽度
        titleCollapse : false, 
        //animCollapse:false,//True 表示为面板闭合过程附有动画效果,默认为true，
        hideCollapseTool:false,  ///    true为隐藏 面板收缩的按钮 
        //boxMinWidth :210,
        //boxMaxWidth:280,
        minSize: 200,
        maxSize: 400,
        baseCls : 'x-plain',
        items:[formSearch],
        listeners:{
            'collapse':function(){
                if (Number(Ext.getCmp('grideast').collapsed))
                {
                    Ext.getCmp('grideast').expand();
                }
            },
            'beforeexpand':function(){
                ///用expand事件会出现展开收缩两次后展开收缩按钮就消失了
                if (!Number(Ext.getCmp('grideast').collapsed))
                {
                    Ext.getCmp('grideast').collapse();
                }
            }
        }
    });
    var gridCenter = new Ext.Panel({
        title:'医嘱项列表',
        id : 'gridcenter',
        region : 'center',
        width:450,
        split:true,
        layout:'border',
        items:[grid]
    });
    
    var grideast = new Ext.Panel({
        id : 'grideast',
        title:'医嘱项信息',
        region : 'east',
        width:760,
        split:true,
        collapsed:true,
        collapsible:true,
        titleCollapse : false, 
        //animCollapse:false,
        boxMinWidth:760,
        layout:'border',
        hideCollapseTool:false,
        items:[tabs],
        listeners:{
            
            'collapse':function(){
                if (Number(Ext.getCmp('formsearch').collapsed))
                {
                    Ext.getCmp('formsearch').expand();
                }
            },
            'beforeexpand':function(){
                ///用expand事件会出现展开收缩两次后展开收缩按钮就消失了
                if (!Number(Ext.getCmp('formsearch').collapsed))
                {
                    Ext.getCmp('formsearch').collapse();
                 }
            }
        
        }
    });
    Ext.BDP.FunLib.Component.KeyMap(btnAddHandler,function(){},function(){});   
    ///ofy10
    // Ext.getCmp("DEPUnitDR").setValue(DefUnit);
    
    
    
    //var loadflag=0;
    /////////////////////用Viewport可自适应高度跟宽度///////////////////////////////////////////////  `
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        width:900,
        active:0,
        items: [FormSearch,gridCenter,grideast],
        listeners:{
            
            'afterlayout':function(){
                /*
                //打开页面默认加载数据(以下)
                //if (loadflag==0)
                //{
                    //loadflag=1
                    grid.getStore().baseParams={
                        hospid:hospComp.getValue(),
                        enableflag:Ext.getCmp("enableflag").getValue(),
                        ownflag:Ext.getCmp("ownflag").getValue()
                     };
                    gridstore.load({ 
                        
                        params: { start: 0, limit: pagesize_main}, 
                        callback: function(r, options, success){
                            if(success){
                            }
                            
                        }
                    });
                //}*/
            }
        
        }
    });
    
    
});