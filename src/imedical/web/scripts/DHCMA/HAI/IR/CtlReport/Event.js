function InitReportWinEvent(obj){
	var CheckFlg = 0;  
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	obj.LoadEvent = function(args){
		obj.reloadgridApply();
		obj.LoadDataCss();
		obj.LoadPatInfo();
	}
	
	//չ�ֲ��˻�����Ϣ
	obj.LoadPatInfo = function (){
		obj.AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdmInfo",	
			aEpisodeID: EpisodeID
		},false);
		if (obj.AdmInfo.total>0) {
			var AdmInfo = obj.AdmInfo.rows[0];
			$('#txtRegNo').val(AdmInfo.PapmiNo);
			$('#txtName').val(AdmInfo.PatName);
			$('#txtSex').val(AdmInfo.Sex);
			$('#txtAge').val(AdmInfo.Age);
			$('#txtBed').val(AdmInfo.AdmBed);
			$('#txtNo').val(AdmInfo.MrNo);
			$('#txtAdmDate').val(AdmInfo.AdmDate);
			$('#txtDischDate').val(AdmInfo.DischDate);
			$('#txtMainTreat').val(AdmInfo.MainDiag);
			
		}
	}
	
	//չʾ������Ϣ
	obj.ReportInfo = function(aResultID,aMRBRepID){	
		
		//�����
    	//$HUI.radio('input[type=radio][name=chkInfType]').uncheck();
		$HUI.radio('input[type=radio][name=chkInsulatType]').uncheck();
		$HUI.radio('input[type=radio][name=chkTreatMent]').uncheck();
		$HUI.radio('input[type=radio][name=chkEnvMent]').uncheck();
		$HUI.radio('input[type=radio][name=chkClothMent]').uncheck();
		$HUI.radio('input[type=radio][name=Assess]').uncheck();
		
		$HUI.checkbox('input[type=checkbox][name=chkContactList]').uncheck();	
		//$HUI.checkbox('input[type=checkbox][name=chkDropletList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkPlaceList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkUnitList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkVisitList]').uncheck();	
		$HUI.checkbox('input[type=checkbox][name=chkEndList]').uncheck();
		$HUI.checkbox('input[type=checkbox][name=chkDoTS]').uncheck();	
		$('#txtResume').val("");		
		$('#txtComments').val("");
		if (obj.MRBOutLabType!="��ԺЯ��"){
			var Flg=$cm({
				ClassName:"DHCHAI.IR.INFMBR",
				MethodName:"CheckIsMap",
				aResultID:aResultID
			},false);
			if(parseInt(Flg)== '-1'){
				$.messager.alert("��ʾ","������¼�б걾δά����׼���ƶ��գ�����ά���걾��׼����!", 'info');
				return ;	
			}else if (parseInt(Flg)== '-2') {
				$.messager.alert("��ʾ","������¼��ϸ��δά����׼���ƶ��գ�����ά��ϸ����׼����!", 'info');
	            return ;     
		    }else if (parseInt(Flg)== '-3') {
			    $.messager.alert("��ʾ","������¼��ϸ�����Ƕ�����ҩ��������ά��������ҩ������!", 'info');
		        return ;     
		    }
		}
	    var RepStatus="";
	    if (aMRBRepID) { //��ֵ
			var objInfo = $m({    			 //��ȡ����               
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				MethodName:"GetReportString",
				aRepID:aMRBRepID
			},false);
			if (!objInfo) return;
			var RepInfo = $m({                  
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				MethodName:"GetMBRRepID",
				aEpisodeDr:EpisodeID,
				aINFMBRID:aMRBRepID
			},false);
			if (RepInfo){
				RepDate=RepInfo.split("^")[1];
				RepUser=RepInfo.split("^")[3];
				RepStatus=RepInfo.split("^")[5];				
				$('#txtUpdateUser').val(RepUser);
				$('#txtUpdateDate').val(RepDate);
			}
			//�ٸ�ֵ
			//��Ⱦ����
		    //var InfType =objInfo.split("^")[9].split(",")[0];
		    //$('#chkInfType'+InfType).radio('setValue', (InfType!="" ? true:false)); 
		         
		    //���뷽ʽ
		    var InsulatType =objInfo.split("^")[12].split(",")[0];
		    $('#chkInsulatType'+InsulatType).radio('setValue', (InsulatType!="" ? true:false));     
   
	        //�����ʩ��ֵ���ɶ�ѡ
			var ContactList =objInfo.split("^")[13]; 
			for (var len=0; len < ContactList.length;len++) {        
				var value = ContactList.split(',')[len];
				$('#chkContactList'+value).checkbox('setValue', (value!="" ? true:false));                
			}
			/*  
		    //��ĭ����
		    var DropletList =objInfo.split("^")[14]; 
			for (var len=0; len < DropletList.length;len++) {        
				var value = DropletList.split(',')[len];
				$('#chkDropletList'+value).checkbox('setValue', (value!="" ? true:false));                
			}  
			*/
		    //��Ⱦ���˰���
		    var PlaceList =objInfo.split("^")[15]; 
	        for (var len=0; len < PlaceList.length;len++) {        
				var value = PlaceList.split(',')[len];
				$('#chkPlaceList'+value).checkbox('setValue', (value!="" ? true:false));                
			}  
		    
		    //���뵥Ԫ����
		    var UnitList =objInfo.split("^")[16]; 
	        for (var len=0; len < UnitList.length;len++) {        
				var value = UnitList.split(',')[len];
				$('#chkUnitList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
			//���뵥Ԫ���ã�����
			$("#txtUnitExt").val(objInfo.split("^")[17])
		    
		    //��Ⱦ�������� 
		  	var TreatMent =objInfo.split("^")[18].split(",")[0];
		    $('#chkTreatMent'+TreatMent).radio('setValue', (TreatMent!="" ? true:false)); 
		     
		    //���������
		    var EnvMent =objInfo.split("^")[19].split(",")[0];
		    $('#chkEnvMent'+EnvMent).radio('setValue', (EnvMent!="" ? true:false)); 
		    
		    //�ú󱻷�����
		    var ClothMent =objInfo.split("^")[20].split(",")[0];
		    $('#chkClothMent'+ClothMent).radio('setValue', (ClothMent!="" ? true:false)); 
		    
		    //̽���߹���
		    var VisitList =objInfo.split("^")[21]; 
	        for (var len=0; len < VisitList.length;len++) {        
				var value = VisitList.split(',')[len];
				$('#chkVisitList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
		    
		    //��ĩ����  
		    var EndList =objInfo.split("^")[22]; 
	        for (var len=0; len < EndList.length;len++) {        
				var value = EndList.split(',')[len];
				$('#chkEndList'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
		
			$('#txtResume').val(objInfo.split("^")[23]);
			var Assess = objInfo.split("^")[27];
	        if (Assess) {
		        $HUI.radio("#Assess-"+Assess).setValue(true); // ����
	        }	
	        $('#txtComments').val(objInfo.split("^")[28]);
	        
	        //�׸�����  
		    var DoTS =objInfo.split("^")[29]; 
	        for (var len=0; len < DoTS.length;len++) {        
				var value = DoTS.split(',')[len];
				$('#chkDoTS'+value).checkbox('setValue', (value!="" ? true:false));                
			} 
	            
		}
		obj.DisplayButtonStatus(RepStatus);
	}
	
	// չʾ���������ť
	obj.DisplayButtonStatus = function(RepStatus){
		if (!RepStatus) {
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#RepStatus').text("");
			$('#btnSaveTmp').show();
			$('#btnSaveRep').show();
		} else if (RepStatus == '1') {
			$('#btnSaveTmp').show();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('�ύ')});
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnPrint').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').show();
			$('#RepStatus').text($g('����'));
		}else if (RepStatus =='2') {		
			$('#btnSaveTmp').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('�ύ')});
			if (CheckFlg !='1') {
				$('#btnCheck').hide();				
			}else{
				$('#btnCheck').show();				
			}
			$('#btnUnCheck').hide();
			$('#btnPrint').show();
			$('#SumAssess').show();
			$('#Comments').show();			
			$('#RepStatus').text($g('�ύ'));
		} else if (RepStatus == '3') {
			$('#btnSaveRep').hide();
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
            $('#btnUnCheck').show();
            if (CheckFlg !='1') {
                $('#btnDelete').hide();
                $('#btnUnCheck').hide();
            }
            
			$('#SumAssess').show();
			$('#Comments').show();
			$('#RepStatus').text($g('���'));
		}else if (RepStatus =='4') {
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('�����ύ')});
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#RepStatus').text($g('ɾ��'));
		}else if (RepStatus =='6') {
			$('#SumAssess').hide();
			$('#Comments').hide();
			$('#btnSaveRep').show();
			$('#btnSaveRep').linkbutton({text:$g('�����ύ')});
			$('#btnSaveTmp').hide();
			$('#btnCheck').hide();
			$('#btnUnCheck').hide();
			$('#btnDelete').hide();
			$('#btnPrint').hide();
			$('#RepStatus').text($g("ȡ�����"));
		}
	}
	
	//���棨Status=1��//�ύ������Status=2��
	obj.SaveReport = function(Status, aFlg) {
        //��ѡ��ѡ��ȡֵ
        //var InfType=Common_RadioValue('chkInfType');	//��Ⱦ����
        var InsulatType=Common_RadioValue('chkInsulatType');       //���뷽ʽ
        var ContactList=Common_CheckboxValue('chkContactList');	//�����ʩ
        var DropletList='';  //��ĭ����
        var PlaceList=Common_CheckboxValue('chkPlaceList');	//��Ⱦ���˰���
        var UnitList=Common_CheckboxValue('chkUnitList');//���뵥Ԫ����
        var TreatMent=Common_RadioValue('chkTreatMent');//��Ⱦ��������
        var EnvMent=Common_RadioValue('chkEnvMent');//���������
        var ClothMent=Common_RadioValue('chkClothMent');//�ú󱻷�����
        var VisitList=Common_CheckboxValue('chkVisitList');//̽���߹���
        var EndList=Common_CheckboxValue('chkEndList');     //��ĩ����
        var DoTS=Common_CheckboxValue('chkDoTS');     //�׸�����
    	var UnitExt  = $("#txtUnitExt").val();	//�������뵥Ԫ
        var Resume   = $("#txtResume").val();	//�������
        var Comments = $("#txtComments").val(); // add 20211116 ��ע
		var ErrorStr="";  
		var ID           = obj.MRBRepID;
		var AdmID        = EpisodeID;
		var LabRepDr     = LabRepID;
		var SubmissLocDr="",SpecimenDr="",SubmissDate="",BactDicDr="",BactDesc= "",MRBDicDr= "";LabResID="";	
		var rows = $('#gridApply').datagrid('getSelected');
		if (rows) {
			SubmissLocDr = rows.LocID;
			SpecimenDr   = rows.SpeID;
			SubmissDate  = rows.ActDate;
			BactDicDr    = rows.BacID;
			BactDesc     = rows.Bacteria;
			MRBDicDr     = rows.MRBID;
			LabRepDr     = rows.LabRepID;
			LabResID     = rows.LabResID;   //������Ŀ���
		}else {
			 ErrorStr += ($g('��ѡ���ͼ��¼���ٱ��汨��!')+'<br/>');
		}
		/*
		if (InfType=='') {
	        ErrorStr += '��Ⱦ���Ͳ�����Ϊ��!<br/>';
        }
        */
        if (InsulatType=='') {
	        ErrorStr += ($g('���뷽ʽ������Ϊ��!')+'<br/>');
        }
        if (ContactList=='') {
	        ErrorStr += ($g('�����ʩ������Ϊ��!')+'<br/>');
        }  
       if (ErrorStr != '') {
			$.messager.alert("��ʾ",ErrorStr, 'info');
			return false;
		}
        //��ǿ������
        var HandHygiene="";
        //��������
        var SecondCase="";
        //��˱����ܽ�������
		var RepAssess ="";
	    var AssessVal = $('#SumAssess input[name="Assess"]:checked').val();
	    if(AssessVal){
			RepAssess =AssessVal;
		}
		var IROutLabRepDr="";
		if (obj.MRBOutLabType=="��ԺЯ��"){
			var LabRepDr  = "";
			IROutLabRepDr = obj.ResultID;
		}
		var InputMBRStr = ID;
		InputMBRStr += "^" + AdmID;
		InputMBRStr += "^" + LabRepDr;
		InputMBRStr += "^" + SpecimenDr;
		InputMBRStr += "^" + SubmissDate;
		InputMBRStr += "^" + SubmissLocDr;
		InputMBRStr += "^" + BactDicDr;
		InputMBRStr += "^" + BactDesc;
		InputMBRStr += "^" + MRBDicDr;
		InputMBRStr += "^" + "";
		InputMBRStr += "^" + HandHygiene;
		InputMBRStr += "^" + SecondCase;
		InputMBRStr += "^" + InsulatType;
		InputMBRStr += "^" + ContactList;
		InputMBRStr += "^" + DropletList;
		InputMBRStr += "^" + PlaceList;
		InputMBRStr += "^" + UnitList;
		InputMBRStr += "^" + UnitExt;
		InputMBRStr += "^" + TreatMent;
		InputMBRStr += "^" + EnvMent;
		InputMBRStr += "^" + ClothMent;
		InputMBRStr += "^" + VisitList;
		InputMBRStr += "^" + EndList;
		InputMBRStr += "^" + Resume;
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + "";
	    InputMBRStr += "^" + $.LOGON.USERID;
	    InputMBRStr += "^" + RepAssess;      //�����ܽ�������
	    InputMBRStr += "^" + Comments;
	    InputMBRStr += "^" + IROutLabRepDr;
	    InputMBRStr += "^" + DoTS;
	    //������Ϣ
	   	var InputRepStr = "";         // ����ID DHCHAI.IR.INFReport	
		InputRepStr += "^" + AdmID;
		InputRepStr += "^" + "5";
		InputRepStr += "^" + "";
		InputRepStr += "^" + "";
		InputRepStr += "^" + $.LOGON.LOCID;
		InputRepStr += "^" + $.LOGON.USERID; 
		InputRepStr += "^" + Status;
		
	    // ��־��Ϣ
	    var InputLogStr = "";            // DHCHAI.IR.INFReport
		InputLogStr += "^" + Status;     // ״̬
	    InputLogStr += "^" + "";         // �������
	    InputLogStr += "^" + $.LOGON.USERID;
	           
		var InputStr = InputMBRStr + "#" + InputRepStr + "#" + InputLogStr + "#" + aFlg;
		var retval = $cm ({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			MethodName:"SaveReport",
			ResultSetType:"array",
			aInputStr:InputStr,
			aSeparete:"^"
		},false);
		obj.MRBRepID = retval;					
		return retval;
	}
	
	//���ذ�ť�¼�
	$('#btnSaveTmp').on("click", function(){	//����
		var ret=obj.SaveReport("1"); 
		if (!ret) {    //update 20210708 ��ֹ������ʾ�󣬱���ID��ֵΪ��
			return;
		}else {
			if(parseInt(ret)>0){
				
				obj.MRBRepID = ret;
				var rows = $('#gridApply').datagrid('getSelected');
				if (!rows.MRBRepID) {
					var index = $("#gridApply").datagrid('getRowIndex', rows);
					$('#gridApply').datagrid('updateRow',{
						index: index,
						row: {
							MRBRepID: obj.MRBRepID
						}
					});
				}
				obj.ReportInfo(obj.ResultID,obj.MRBRepID);
				$.messager.alert("��ʾ", "����ɹ�", 'info');
				return;	
			}else{
				obj.MRBRepID = '';
				if(parseInt(ret)=='-1') {
					$.messager.alert("��ʾ",'����ϸ���������ݱ���ʧ��!','info');
					return false;
				}else if (parseInt(ret)=='-2') {
					$.messager.alert("��ʾ",'������Ϣ����ʧ��!','info');
					return false;
				}else if (parseInt(ret)=='-3') {
					$.messager.alert("��ʾ",'������־��Ϣ����ʧ��!','info');
					return false;
				}
			}
		}
	});
	$('#btnSaveRep').on("click", function(){	//�ύ
	    var btnValue = document.getElementById("btnSaveRep").innerText;
	    if (btnValue=="�����ύ") {
		    var ret=obj.SaveReport("2","1"); 
		   
	    } else {
		   var ret=obj.SaveReport("2");  
	    }	
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			var rows = $('#gridApply').datagrid('getSelected');
			if (!rows.MRBRepID) {
				var index = $("#gridApply").datagrid('getRowIndex', rows);
				$('#gridApply').datagrid('updateRow',{
					index: index,
					row: {
						MRBRepID: obj.MRBRepID
					}
				});
			}
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("��ʾ", "�ύ�ɹ�", 'info');
			return;	
		}else{
			obj.MRBRepID = '';
			if(parseInt(ret)=='-1') {
				$.messager.alert("��ʾ",'����ϸ�����������ύʧ��!','info');
				return false;
			}else if (parseInt(ret)=='-2') {
				$.messager.alert("��ʾ",'������Ϣ�ύʧ��!','info');
				return false;
			}else if (parseInt(ret)=='-3') {
				$.messager.alert("��ʾ",'������־��Ϣ�ύʧ��!','info');
				return false;
			}
		}
	});
	$('#btnCheck').on("click", function(){	//���
		var ret=obj.SaveReport("3"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("��ʾ", "��˳ɹ�", 'info');
			return;	
		}else{
			$.messager.alert("��ʾ",'���ʧ��','info');
			return false;
		}	
	});
	$('#btnUnCheck').on("click", function(){	// ȡ�����
		var ret=obj.SaveReport("6"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			var rows = $('#gridApply').datagrid('getSelected');
			if (!rows.MRBRepID) {
				var index = $("#gridApply").datagrid('getRowIndex', rows);
				$('#gridApply').datagrid('updateRow',{
					index: index,
					row: {
						MRBRepID: obj.MRBRepID
					}
				});
			}
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("��ʾ", "ȡ����˳ɹ�", 'info');
			return;	
		}else{
			obj.MRBRepID = '';
			if(parseInt(ret)=='-1') {
				$.messager.alert("��ʾ",'����ϸ�����������ύʧ��!','info');
				return false;
			}else if (parseInt(ret)=='-2') {
				$.messager.alert("��ʾ",'������Ϣ�ύʧ��!','info');
				return false;
			}else if (parseInt(ret)=='-3') {
				$.messager.alert("��ʾ",'������־��Ϣ�ύʧ��!','info');
				return false;
			}
		}
	});
	$('#btnDelete').on("click", function(){	//ɾ��
		var ret=obj.SaveReport("4"); 
		if(parseInt(ret)>0){
			obj.MRBRepID = ret;
			obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			$.messager.alert("��ʾ", "ɾ���ɹ�", 'info');
			return;	
		}else{
			$.messager.alert("��ʾ",'ɾ��ʧ��','info');
			return false;
		}	
	});
	
	$('#btnPrint').on("click", function(){		//��ӡ
		if (!obj.MRBRepID) return;
		//var fileName="{DHCHAI.INF.MBRReport.raq(aMRBRepID="+obj.MRBRepID+")}";
		//DHCCPM_RQDirectPrint(fileName);	
		var fileName="DHCHAI.INF.MBRReport.raq&aMRBRepID="+obj.MRBRepID;
		DHCCPM_RQPrint(fileName);
	});
	$('#btnClose').on("click", function(){		//�ر�
		websys_showModal('close');
	});
	
	//���ؼ�������
	obj.reloadgridApply = function(){
		$("#gridApply").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryMRBByEpsodeDr",
			ResultSetType:"array",
			aEpisodeDr:EpisodeID,
			page:1,
			rows:200
		},function(rs){
			$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	
	obj.MenuEdit = function(index,ResultID,MRBOutLabType,RowID) {
		var e = event || window.event;
		$('#gridApply').datagrid("clearSelections"); //ȡ������ѡ���� 
		$('#gridApply').datagrid("selectRow", index); //��������ѡ�и��� 
		$('#menu').menu({
		    onClick:function(item){
		       	if (MRBOutLabType=="��ԺЯ��"){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("������ʾ", "���ʧ��!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '��ǳɹ���',type:'success',timeout: 1000});
						obj.reloadgridApply(); //ˢ�µ�ǰҳ
					}
				}else{
			       	var ret = $m({
						ClassName:"DHCHAI.DP.LabVisitRepResult",
						MethodName:"UpdateInfType",
						aID:ResultID,
						aMakeInfType:item.id,
						aIsByHand:1
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("������ʾ", "���ʧ��!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '��ǳɹ���',type:'success',timeout: 1000});
						obj.reloadgridApply(); //ˢ�µ�ǰҳ
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //�����������ʾ�˵� 
			top: e.pageY
		});
	}
	
}