/**
	kemaolin
	2020-03-31
	�����ϸ checkdetail.js
*/
$(function(){
	initView();	
})
function initView(){
	runClassMethod("web.DHCCKBMonMaster","QueryCheckDetail",{"id":RowID},function(data){
		if(data!=""){
			$("#PatName").val(data.PatName); //��������
			$("#PatSex").val(data.SexProp); //�Ա�
			$("#PatBDay").val(data.AgeProp); //��������
			$("#Height").val(data.Height); //���
			$("#Weight").val(data.Weight); //����
			$("#ProFess").val(data.ProfessProp); //ְҵProFess
			$("#SpecGrps").val(data.SpecialPop.join(" ")); //������Ⱥ
			$("#PreFlag").val(data.PreFlag); //����
			$("#itemAyg").datagrid("loadData",data.HisAllergy) //����Դ
			$("#itemDis").datagrid("loadData",data.Disease)  //�������
			$("#itemLab").datagrid("loadData",data.itemLab) //����
			$("#itemOper").datagrid("loadData",data.itemOper) //����
			$("#itemOrder").datagrid("loadData",data.Drug) //ҽ���б�
		}	
	},"json");
}
