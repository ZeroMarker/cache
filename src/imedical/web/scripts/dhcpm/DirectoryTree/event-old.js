//Create by zzp
// 20150521
//结构树管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	obj.LoadEvent = function(args){
	  obj.DirTreeAdd.on("click",obj.DirTreeAdd_OnClick,obj);
 };
 obj.DirTreeAdd_OnClick=function(){
 alert('新增');
 };
}