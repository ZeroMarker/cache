function InitReportWin(){
	var obj = new Object();
	obj.OperID="";
	obj.OperCompl="";
	obj.cboSurgery = $HUI.combobox('#cboSurgery', {
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'OperID',
		textField: 'OperAndDateInfo',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.IMP.IPS.OperCompRegSrv';
			param.QueryName = 'GetAnOpListForM';
			param.ResultSetType = 'array';
			param.EpisodeId=EpisodeID;
		}
	});  
	var res = $m({
		ClassName:"DHCMA.IMP.BTS.OperCompDicSrv",
		QueryName:"QryOperCompDic",
		aIsActive:"1"
	}, false);
	var objres = JSON.parse(res);
	var addStr="";
	var j=0;
	for(var i =0;i<objres.rows.length;i++){
		if(j==0){
			addStr=addStr+"<tr class='report-tr'>";
		}
		var str = "<td><input valign='top' class='hisui-checkbox' type='checkbox' style='width:282px' id='"+objres.rows[i].BTCode+"' label='"+objres.rows[i].BTDesc+"' name='ComplType' disabled value='"+objres.rows[i].BTID+"'/></td>"
		addStr = addStr+str
		if(j==2){
			addStr=addStr+"</tr>";
		}
		j=j+1
		if(j==3){
			j=0;
		}
	}
	var text = "<td>"+$g('其他类型')+"&nbsp;&nbsp;<input id='OtherType' class='textbox' style='width:130px' /></td>"
	$("#ComplTypes").append(addStr+text);
	
	var resLevel = $m({
		ClassName:"DHCMA.IMP.BTS.OperCompLvlSrv",
		QueryName:"QryOperCompLvlIsCheck",
		aIsActive:"1"
	}, false);
	var objresLevel = JSON.parse(resLevel);
	var addLevelStr="";
	for(var i =0;i<objresLevel.rows.length;i++){
		if(objresLevel.rows[i].IsCheck=="1"&&objresLevel.rows[i].IsChildCode=="0"){
			var str = "<tr class='report-tr'><td colspan='6' ><input class='hisui-radio' type='radio' name='ComplLevel' disabled data-options=\"radioClass:'hischeckbox_square-blue'\" value='"+objresLevel.rows[i].BTID+"' /></td><td style='width:900px'>"+objresLevel.rows[i].BTCode+$g('级')+objresLevel.rows[i].BTDesc+"</td></tr>"
			addLevelStr = addLevelStr+str
		}else if(objresLevel.rows[i].IsCheck=="0"&&objresLevel.rows[i].IsChildCode=="0"){
			var str = "<tr class='report-tr'><td colspan='6' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td style='width:900px;color:#666666;'>"+objresLevel.rows[i].BTCode+$g('级')+objresLevel.rows[i].BTDesc+"</td></tr>"
			addLevelStr = addLevelStr+str
		}else{
			var str = "<tr class='report-tr'><td colspan='6' ><input class='hisui-radio' type='radio' name='ComplLevel' disabled data-options=\"radioClass:'hischeckbox_square-blue'\" value='"+objresLevel.rows[i].BTID+"' /></td><td style='width:900px'>"+objresLevel.rows[i].BTCode+$g('级')+objresLevel.rows[i].BTDesc+"</td></tr>"
			addLevelStr = addLevelStr+str
		}
	}
	$("#Level").append(addLevelStr);

	$.parser.parse();        // 解析整个页面 
	//$('#InfoDiv').css("display","none");
	if(IMPOrdNo!=""&&"undefined"!=IMPOrdNo){
		obj.IMPOrdNo=IMPOrdNo;
		obj.RecordRet = $m({
			ClassName:"DHCMA.IMP.IP.IMPRecord",
			MethodName:"GetObjByEpisodeIDAndCategory",
			aEpisodeID:EpisodeID,
			aCategory:CategoryDR,
			aIMPOrdNo:IMPOrdNo,
			aRegType:"1"
		}, false);
	}
	if(obj.RecordRet){
		obj.objRecordRet = JSON.parse(obj.RecordRet);
		var RegRet = $m({
			ClassName:"DHCMA.IMP.IP.IMPRegister",
			MethodName:"GetObjectByRecordDr",
			aIMPRecordDr:obj.objRecordRet.ID,
			aRegType:"1"
		}, false);
	}
	if (RegRet) {
		obj.objRegRet = JSON.parse(RegRet);
		$cm({
			ClassName:"DHCMA.IMP.IP.OperCompReg",
			MethodName:"GetObjByRegisterDr",
			aRegisterDr:obj.objRegRet.ID
		},function(objOperCompl){
			obj.OperCompl=objOperCompl
			if (objOperCompl) {
				obj.OperID = objOperCompl.OperationID;
				var aEpisodeID = EpisodeID;
				obj.load_OperDate(aEpisodeID,obj.OperID);
				$HUI.combobox("#cboSurgery",{
						value:obj.OperID
					});
				if(objOperCompl.IsOperCompl==1){
					Common_SetRadioValue('IsSur','Y');
					$HUI.datebox("#ComplDate",{disabled:false});
					$HUI.checkbox("input[name=ComplType]",{disabled:false});
					$HUI.radio("input[name=ComplLevel]",{disabled:false});
					
					$HUI.datebox("#ComplDate",{
						value:objOperCompl.ComplDate
					})
					$HUI.radio("input[name=ComplLevel][value="+objOperCompl.ComplLevelDr+"]",{
						checked:true
					});
					var arry = (objOperCompl.ComplTypes).split("!");
					for(var i=0;i<arry.length;i++){
						$HUI.checkbox("input[name=ComplType][value="+arry[i]+"]",{
							checked:true
						});
					}
					if(objOperCompl.OtherComplType!=""){
					$('#OtherType').val(objOperCompl.ComplTypeTxt);
					}
					/**if ($('#OtherComplType').is(":checked")== true) {
			            $('#OtherTD').css('display','block');
			        } else {
				        $('#OtherType').val("");
			        	$('#OtherTD').css('display','none');
			        }**/
				}
				var ReportStatus = $m({
					ClassName:"DHCMA.Util.BT.Dictionary",
					MethodName:"GetObjById",
					aId:obj.objRegRet.StatusDr
				}, false);
				var ReportStatusJson = JSON.parse(ReportStatus);
				if(ReportStatusJson.BTCode=="Submit"&tDHCMedMenuOper['Check']){
					$('#btnCheck').css("display","");
					$('#btnCheck').linkbutton("enable");
				}else if(ReportStatusJson.BTCode=="Check"){
					$('#btnCheck').css("display","none");
					$('#btnSave').css("display","none");
					$('#btnSave').linkbutton("disable");
					$('#btnCheck').linkbutton("disable");
					if(tDHCMedMenuOper['Check']){
						$('#btnCancelCheck').css("display","");
					}
				}
			}
		});
	
	}
	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
