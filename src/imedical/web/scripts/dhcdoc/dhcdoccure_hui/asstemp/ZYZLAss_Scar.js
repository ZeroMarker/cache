var ZYZLAss_Scar=(function(){
	function Init(){
		PageHandle();
		
		
		if(ServerObj.DCAssRowId==""){
			//Ĭ�ϵ�ǰʱ��,�����������Ϊ����
			//assTempShow.js
			setDefAssDate('SCAR_Date');
		}
		//ɫ�� M
		$HUI.combobox("#SCAR_Color", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('Ƥ����ɫ�������������ݱȽϽ�������')},
				{id:'1',text:$g('ɫ���ǳ')},{id:'2',text:$g('���ɫ��')},
				{id:'3',text:$g('ɫ�����')}
			]
		 });
		 
		 //Ѫ�ֲܷ� V
		 $HUI.combobox("#SCAR_BloVes", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('������ɫ�������������ݽ���')},
				{id:'1',text:$g('��ɫƫ�ۺ�')},
				{id:'2',text:$g('��ɫƫ��')},
				{id:'3',text:$g('��ɫ����ɫ')}
			]
		 });
		 
		 //����� P
		 $HUI.combobox("#SCAR_Soft", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('����')},
				{id:'1',text:$g('����ģ�������������Ƥ���ܱ��εģ�')},
				{id:'2',text:$g('��˳�ģ���ѹ�����ܱ��εģ�')},
				{id:'3',text:$g('Ӳ�ģ����ܱ��εģ��ƶ��ʿ�״����ѹ����������')},
				{id:'4',text:$g('��������֯����״���̺���չʱ��������')},
				{id:'5',text:$g('�������̺��������������²з���Ť����')}
			]
		 });
		 
		 //��� H
		 $HUI.combobox("#SCAR_Thick", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			enterNullValueClear:false,
			data: [
				{id:'0',text:$g('����')},
				{id:'1',text:$g('=/>0��1mm')},
				{id:'2',text:$g('>1��2mm���ױ���')},
				{id:'3',text:$g('>2��4mm')},
				{id:'4',text:'>4mm'}
			]
		 });
		 
		$HUI.combobox("input[comboname^='Score']",{
			onChange:function(newvalue,oldvalue){
			    TakCalScore(newvalue,oldvalue);
			}
		});
	}
	
	function PageHandle(){
		/*$(".panel-body .panel").css({
			"margin-bottom":"0px"
		})
		$("#ZYZLAss_Scar").css({
			"margin":"10px 0px"
		})
		
		$(".item-table-line tr:last-child td").css({
			"border-bottom":"none"
		})

		$("#ZYZLAss_Scar").panel("resize",{height:79})	
		*/
	}
	
	function TakCalScore(newvalue,oldvalue){
		var Score=$("#SCAR_Score").val();
		if(Score==""){Score=0}
		if(oldvalue==""){oldvalue=0}
		var TotalScore=parseInt(Score)+parseInt(newvalue)-parseInt(oldvalue)
		$("#SCAR_Score").val(TotalScore)
	}
	
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();