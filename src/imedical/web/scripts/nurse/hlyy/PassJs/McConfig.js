/*--------------------------------------------------------------------------*/
/*  McConfig.js
 *  3.2.1 build 2012-08-14
 *  (c) 1997-2012 Medicom
 *--------------------------------------------------------------------------*/
this.WebServiceUrl = "http://10.240.232.161/PassWebService";//请把IP地址改为美康合理用药服务器IP地址
this.IsAsyncRecipeCheck = false; //false表示同步，true表示异步

var MC_WindowWidth = 770; //HIS系统中弹出窗口较小-宽(px)
var MC_WindowHeight = 530; //HIS系统中弹出窗口较小-高(px)

//调试模式设置
this.IsDebugDrugQueryInfoModel = false;//《查询》传入的查询数据
this.IsDebugPatient = false;//   《审查》传入的病人基本信息
this.IsDebugRecipes = false;//   《审查》传入的处方
this.IsDebugAllergens = false;// 《审查》传入的过敏史
this.IsDebugMedConds = false;//  《审查》传入的病生状态 
this.IsDebugResultValue =false;//《返回值》
this.IsDebugShowTime = false;//  《模块执行时间》


this.DebugShowPanel_DrugQueryInfoModel = "ShowResultMsg";//显示调试传入的查询数据的控件名
this.DebugShowPanel_Patient = "ShowResultMsg";    //显示调试信息的控件名
this.DebugShowPanel_Recipes = "ShowResultMsg";    //显示调试传入的处方的控件名
this.DebugShowPanel_Allergens = "ShowResultMsg";  //显示调试传入的过敏史的控件名
this.DebugShowPanel_MedConds = "ShowResultMsg";   //显示调试传入的病生状态的控件名
this.DebugShowPanel_ResultValue = "ShowResultMsg";//显示返回值调试的控件名