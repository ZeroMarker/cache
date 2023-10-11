//页面Gui
function InitWin(){
	var obj = new Object();
	obj.QryOpption="label01"
	
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID)
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			Common_ComboToLoc("cboInfLocation",HospIDs,'','I','E');
		 }
	 })
	$("#redkw").keywords({
    	singleSelect:true,
   	 	labelCls:'red',
    	items:[
        	{text:'手术部位统计图',id:'label01',selected:true},
        	{text:'Ⅰ类切口统计图',id:'label02'},
        	{text:'手术部位感染诊断统计图',id:'label03'}
   		 ],
    	onClick:function(v){
	    	obj.keyWords_onClick(v.id);
	    }
	});
	
	InitEvent(obj);
	return obj;
}
$(InitWin);