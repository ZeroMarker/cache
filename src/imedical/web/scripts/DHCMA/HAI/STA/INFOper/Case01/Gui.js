//ҳ��Gui
function InitWin(){
	var obj = new Object();
	obj.QryOpption="label01"
	
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID)
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//��ҽԺ����Select�¼������¿����б�
			HospIDs=rec.ID;
			Common_ComboToLoc("cboInfLocation",HospIDs,'','I','E');
		 }
	 })
	$("#redkw").keywords({
    	singleSelect:true,
   	 	labelCls:'red',
    	items:[
        	{text:'������λͳ��ͼ',id:'label01',selected:true},
        	{text:'�����п�ͳ��ͼ',id:'label02'},
        	{text:'������λ��Ⱦ���ͳ��ͼ',id:'label03'}
   		 ],
    	onClick:function(v){
	    	obj.keyWords_onClick(v.id);
	    }
	});
	
	InitEvent(obj);
	return obj;
}
$(InitWin);