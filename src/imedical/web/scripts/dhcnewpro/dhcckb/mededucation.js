/**
  *用药教育js
  *
**/
var EpisodeID = "7";
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();   
	InitDefaultCon();
	InitPresInfo();	
	
}
///初始化就诊信息
function InitPatEpisodeID()
{
	//EpisodeID = getParam("EpisodeID");
}
///初始化页面默认内容
function InitDefaultCon()
{
	
	runClassMethod("web.DHCCKBMedEducation","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$("#PatName").val(jsonObject.PatName);
		$("#PatSex").val(jsonObject.PatSex);
		$("#PatAge").val(jsonObject.PatAge);
		$("#PatDiag").val(jsonObject.PatDiagDesc);
	},'json',false)
}	
///初始化处方信息
function InitPresInfo()
{
	runClassMethod("web.DHCCKBMedEducation","GetPatPresInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var divshow = $("#dataList");
        divshow.text("");				// 清空数据
        		
		var htmlStr = "";
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftbold'>注射用绒促性素</label>"
		htmlStr = htmlStr + 	"<label class='left-20'>频次:</label><span>"+"每周2～3次"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>单次剂量:</label><span>"+"1000～4000单位"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>给药途径:</label><span>"+"肌内注射"+"</span>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>同用药品间隔使用方法</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"同用药品中有两个或以上药品应间隔使用，否则会引起不良相互作用，应告知患者或其照护者间隔使用的方法及使用间隔时间。如抗菌药物跟活菌生态制剂连用要间隔3小时以上。某些药品易与铁、钙、镁、铝、锌等离子螯合，减少吸收，应间隔2-3小时服用。"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>严重药品不良反应前兆</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"某些药品可能会导致严重不良反应，但初期症状并不严重，应明确告知患者或照护者这类症状可能是药品严重不良反应的前兆，应尤为警戒 ，一旦出现类似症状，请立即停药并就医。如黑框警告，警示语中的相关不良反应，应提醒患者注意。可能导致光敏反应，避免阳光直射，剧烈运动可能导致肌腱炎跟肌腱断裂等。容易造成低血压，低血糖，跌倒风险提高"+"</p></div>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftbold'>盐酸坦索罗辛缓释胶囊</label>"
		htmlStr = htmlStr + 	"<label class='left-20'>频次:</label><span>"+"每日一次"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>单次剂量:</label><span>"+"每次一粒（0.2mg）"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>给药途径:</label><span>"+"饭后口服"+"</span>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>用药后的身体反应</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"某些药品在使用后可能会产生一些特殊的身体反应，但不干扰患者的治疗，应告知患者或其照护者这些伴随现象。如引起尿液变色，可能导致困倦"+"</div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>特殊人群和特殊职业者</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"某些药品在特殊人群或特殊职业者使用时，存在需要注意的事项，应交代给患者或其照护者。如：可导致困倦并持续较长时间，服用期间不要操作机器，高空作业或驾驶。本品对胎儿发育有影响，应避免怀孕。老年人慎用，孕妇慎用，怀孕前3个月慎用"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>特殊的储存方法</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"需要采用特殊的储存方法（如冷藏）进行保存的药品，应明确告知患者或其照护者。如避光保存，冷处保存（2-10℃）"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>漏服药品的处理办法</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"说明书有明确说嘛的漏服药品的处理办法，应告知患者或其照护者"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>对用药过程的指导</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"患者不能自行停药的药品，不能超过一天或一周限量，应逐渐加量，逐渐减量，需要时服用应该告知患者具体什么时间，应该按疗程规律服药，用药不得少于3天"+"</p></div>"
		htmlStr = htmlStr + "</div>"
		divshow.append(htmlStr); 	
	},'text',false)
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })