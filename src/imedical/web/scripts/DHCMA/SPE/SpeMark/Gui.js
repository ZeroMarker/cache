function InitSpeMarkWin(){
	var obj = new Object();
	obj.SPM_Input = new Object();
	obj.SPM_Input.SpeID      = SpeID;
	obj.SPM_Input.EpisodeID  = EpisodeID;
	obj.SPM_Input.OperTpCode = OperTpCode;
	
	obj.strAdmInfo ="";
	obj.strSpeInfo ="";
	$.parser.parse(); 
	if (EmrOpen==1){
	    $('#btnList').css('display','none');
    } 
	//病人类型
	obj.cboPatTypeSub = $HUI.combobox('#cboPatTypeSub', {
		url: $URL,
		editable: false,   //小字典不允许编辑
		valueField: 'PTSID',
		textField: 'PTSDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SPEService.PatTypeSub';
			param.QueryName = 'QryPatTypeSubActive';
			param.ResultSetType = 'array';
			param.aPatTypeID = '';
		}
	});
	//转归
	var hospID=session['LOGON.HOSPID'];
	obj.cboPrognosis = Common_ComboToDic("cboPrognosis","SPEPrognosis","^",hospID);  //第四个参数未指定
	
	InitSpeMarkWinEvent(obj);
	obj.LoadEvent();
	return obj;

}
