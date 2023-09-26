//是否往HIS保存健康档案卡信息
var bSaveCardInfo = "0";
//var bSaveCardInfo = "1";

//是否保存userid
var bSaveUserId = "0";
//var bSaveCardInfo = "0";

//个人档案所有地址
var PersonQueryUrl = "../scripts/chss/Person/";
//var PersonQueryUrl = "";

//家庭档案所有地址
var FamilyQueryUrl = "../scripts/chss/Family/";

//个人诊断
var PersonHealthInfoQueryUrl = "../scripts/chss/PersonHealthInfo/";
//var PersonHealthInfoQueryUrl = "";

//公用字典
var DictUrl = "../scripts/chss/Dict/CommonDict/";
//var DictUrl = "";

//性别
var SexQueryUrl = "../scripts/chss/Dict/DictSex/";
//var SexQueryUrl = "";

//模块列表
var ModelQueryUrl = "../scripts/chss/Dict/ModelList/";
//var ModelQueryUrl = "";

//选择机构
var CommunityChoiceQueryUrl = "../scripts/chss/Common/";
//var CommunityChoiceQueryUrl = "";

//与户主关系
var DictKinUrl = "../scripts/chss/Dict/DictKin/";
//var DictKinUrl = "";

//系统字典
var xurl='../scripts/chss/codetable/';
//var xurl = "";

//体检表涉及地址
var CheckRecordUrl = "../scripts/chss/PersonYearCheckRecord/";
//var CheckRecordUrl = "";

//社区机构
var HospitalQueryUrl = "../scripts/chss/Dict/DictHospital/";
//var HospitalQueryUrl = "";

//个人体检
var PersonYearCheckRecordUrl = '../scripts/chss/PersonYearCheckRecord/';
//var PersonYearCheckRecordUrl = "";

//个人长期健康问题
var PersonLongTermProblemUrl = '../scripts/chss/PersonLongTermProblem/';
//var PersonLongTermProblemUrl = "";

//体检
var PersonYearCheckRecordQueryUrl = "../scripts/chss/PersonYearCheckRecord/";
//var PersonYearCheckRecordQueryUrl = "";


//个人地震
var PersonEarthquakeAddQueryUrl = "../scripts/chss/Person/";
//var PersonEarthquakeAddQueryUrl = "";

//省
var DictProvinceQueryUrl = "../scripts/chss/Dict/DictProvince/";
//var DictProvinceQueryUrl = "";

//市
var DictCityQueryUrl = "../scripts/chss/Dict/DictCityType/";
//var DictCityQueryUrl = "";

//区县
var DictSectionQueryUrl = "../scripts/chss/Dict/DictSection/";
//var DictSectionQueryUrl = "";

//乡（镇、街道、办事处）
var DictStreetQueryUrl = "../scripts/chss/Dict/DictStreet/";
//var DictStreetQueryUrl="";

//村
var DictVillageQueryUrl = "../scripts/chss/Dict/DictVillage/";
//var DictVillageQueryUrl = "";

//随访结核
var InfectionUrl = "../scripts/chss/Infection/TB/";
//var InfectionUrl = "";

//乙肝随访情况
var InfectionHBVUrl = '../scripts/chss/Infection/HBV/';
//var InfectionHBVUrl = "";

//传染病卡
var PersonInfectionCardUrl = "../scripts/chss/Infection/PICard/";
//var PersonInfectionCardUrl = "";

//健康教育计划
var HealthEducationPlanUrl="../scripts/chss/HealthEducation/HEPlan/"
//var HealthEducationPlanUrl=""

//妇女保健情况
var WomanUrl = '../scripts/chss/Woman/';
//var WomanUrl = "";

//512地震前健康情况
var PersonHealthBefore512Url = '../scripts/chss/PersonHealthBefore512/';
//var PersonHealthBefore512Url = "";

//个人健康评价表
var PersonHealthAppraiseUrl="../scripts/chss/Person/Appraise/"
//var PersonHealthAppraiseUrl=""

//地震档案
var EarthquakeArchiveUrl = '../scripts/chss/EarthquakeArc/';
//var EarthquakeArchiveUrl = "";

 //儿童保健
var ChildUrl="../scripts/chss/Child/"
//var ChildUrl=""

//随访糖尿病
var InfectionUrl1 = "../scripts/chss/Chronic/Diabete/";
//var InfectionUrl1 = "";

//随访高血压
var InfectionUrl2 = "../scripts/chss/Chronic/HBP/";
//var InfectionUrl2 = "";

//精神病
var InfectionUrl3 = "../scripts/chss/Chronic/Schizo/";
//var InfectionUrl3 = "";

//老年人健康情况
var ElderUrl = '../scripts/chss/Elder/';
//var ElderUrl = "";

//症状情况
var ChronicSymptomUrl = '../scripts/chss/Dict/DictChronicSymptom/';
//var ChronicSymptomUrl = "";

//家庭主要问题
var FamilyProblemUrl = '../scripts/chss/Family/FamilyProblem/';
//var FamilyProblemUrl = "";

//预约管理
var BookingUrl = '../scripts/chss/Booking/';
//var BookingUrl = "";

//权限管理
var pubmodelistUrl="../scripts/chss/authority/"
//var pubmodelistUrl=""

//社区档案
var UnitUrl  = "../scripts/chss/Unit/"
//var UnitUrl = ""

//健康档案统计
var StatPersonUrl = '../scripts/chss/Stat/Person/';
//var StatPersonUrl = "";

//健康教育板报
var HealthEducationBulletinBoardUrl="../scripts/chss/HealthEducation/HEBBoard/"
//var HealthEducationBulletinBoardUrl=""

//健康教育演讲
var HealthEducationLectureUrl="../scripts/chss/HealthEducation/HELecture/"
//var HealthEducationLectureUrl=""

//健康教育材料
var HealthEducationMaterialUrl="../scripts/chss/HealthEducation/HEMaterial/"
//var HealthEducationMaterialUrl=""

//住院记录
var PersonInHosRecordUrl = "../scripts/chss/PersonInHosRecord/"
//var PersonInHosRecordUrl = ""

//社区卫生诊断
var ChartUrl = '../scripts/chss/Chart/';
//var ChartUrl = "";

//慢性病曲线图
var ChronicChartUrl = '../scripts/chss/Chronic/Chart/';
//var ChronicChartUrl = "";

//档案合格指标
var DictRecordQualiIndexUrl = "../scripts/chss/Dict/RecordQualiIndex/";
//var DictRecordQualiIndexUrl="chss.";

//业务监管指标
var DictBussinessCustodyIndexUrl = "../scripts/chss/Dict/CustodyIndex/";
//var DictBussinessCustodyIndexUrl="chss.";

//诊疗记录
//var DiagnoseRecordUrl = "../scripts/chss/DiagnoseRecord/DiagnoseRecord.csp";
var DiagnoseRecordUrl="chss.diagnoserecord.csp";

//个人档案菜单
var PersonModelUrl = "../scripts/chss/Dict/ModelList/ModelQuery.csp";
//var PersonModelUrl="chss.modelquery.csp";

//恶性肿瘤
var MalignancyUrl = "../scripts/chss/Chronic/Malignancy/";
//var MalignancyUrl = "";

//慢病病例专家系统
var ChronicCaseExpertUrl='../scripts/chss/Chronic/ChronicCaseExpert/';
//var ChronicCaseExpertUrl = "";

//迁入迁出
var RollInOutUrl='../scripts/chss/RollInOut/';
//var RollInOutUrl = "";

//死亡管理
var PersonDeathUrl='../scripts/chss/Death/';
//var PersonDeathUrl = "";

//报表端口
var ReportUrl = 'http://127.0.0.1:8086/chssreport/';
//var ReportUrl = "";

//图片上传路径
var PhotoSaveUrl = 'http://10.10.141.45/CHSSWeb/UploadFile/upload.aspx?PersonCode=';
//var PhotoSaveUrl = "";

//图片路径
var PhotoFileUrl = '../scripts/chss/CHSSWeb/UploadFile/upload_files/';
//var PhotoFileUrl = "";



