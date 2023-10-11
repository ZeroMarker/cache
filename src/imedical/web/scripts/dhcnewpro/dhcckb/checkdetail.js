/**
	kemaolin
	2020-03-31
	审查明细 checkdetail.js
*/
$(function(){
	initView();	
})
function initView(){
	runClassMethod("web.DHCCKBMonMaster","QueryCheckDetail",{"id":RowID},function(data){
		if(data!=""){
			$("#PatName").val(data.PatName); //病人姓名
			$("#PatSex").val(data.SexProp); //性别
			$("#PatBDay").val(data.AgeProp); //出生日期
			$("#Height").val(data.Height); //身高
			$("#Weight").val(data.Weight); //体重
			$("#ProFess").val(data.ProfessProp); //职业ProFess
			$("#SpecGrps").val(data.SpecialPop.join(" ")); //特殊人群
			$("#PreFlag").val(data.PreFlag); //怀孕
			$("#itemAyg").datagrid("loadData",data.HisAllergy) //过敏源
			$("#itemDis").datagrid("loadData",data.Disease)  //疾病诊断
			$("#itemLab").datagrid("loadData",data.itemLab) //检验
			$("#itemOper").datagrid("loadData",data.itemOper) //手术
			$("#itemOrder").datagrid("loadData",data.Drug) //医嘱列表
		}	
	},"json");
}
