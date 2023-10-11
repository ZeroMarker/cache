//手术切口调查表(报告)->Event
function InitINFOPSQryWinEvent(obj) {
	
	obj.LoadEvent = function(args){
		
		obj.LoadDataCss();
		obj.LoadPatInfo();
		 //临床科室只允许查看不允许修改
	    if(Admin!=1){   //临床科室
		    $('#txtVisitName').attr("disabled","disabled");
		    $('#dtVistDate').datebox('disable');	
		    $('#cboVisitResult').combobox('disable');	
		    $('#txtPatTel').attr("disabled","disabled");
		    $('#txtVisitResume').attr("disabled","disabled");
		    if (obj.ReportID){
			    obj.ReportInfo(obj.OpsID,obj.OperAnaesID);
			    $('#OprInfoDiv').attr("style","display:none"); //不显示div
		    }else {
			     $('#OprInfoDiv').removeAttr("style");
			     obj.gridOprInfoLoad();
			     obj.reloadOprInfo();
		    }
		} else {   //管理科室
			obj.ReportInfo(obj.OpsID,obj.OperAnaesID);
			$('#OprInfoDiv').attr("style","display:none"); //不显示div
		}
		
		//是否存在与此次感染相关的抗菌用药信息
		$HUI.radio("[name='radInfAnti']",{  
			onChecked:function(e,value){
				var IsInfAnti = $(e.target).val();   //当前选中的值
				if (IsInfAnti==1) {
					$('#divINFAnti').removeAttr("style");
					OpenINFAntiSync();
					obj.refreshgridINFAnti();
				}else {
					$('#gridINFAnti').datagrid('loadData',{total:0,rows:[]});		
					$('#divINFAnti').attr("style","display:none");
				}
			}
		});

	}
		
	//加载手术信息
	obj.reloadOprInfo = function(){
		$("#gridOprInfo").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.INFOPSSrv',
			QueryName:'QryINFOPSByRep',
			aReportID:obj.ReportID,
			aEpisodeID:EpisodeDr,
			IsHist:'',
			page:1,
			rows:200
		},function(rs){
			$('#gridOprInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	
	//展现病人基本信息
	obj.LoadPatInfo = function (){
		// 初始化就诊信息
		obj.AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdmInfo",		
			aEpisodeID: EpisodeDr
		},false);
		
		if (obj.AdmInfo.total>0) {
			var AdmInfo = obj.AdmInfo.rows[0];
			if (AdmInfo.Sex == '女') {
				$('#Sex').removeClass('man').addClass('woman');		
			} else if(AdmInfo.Sex == '男'){
				$('#Sex').removeClass('woman').addClass('man');
			}else {
				$('#Sex').removeClass('woman').removeClass('man').addClass('ukgender');
			}
			$('#txtPatName').text(AdmInfo.PatName);
			$('#Age').text(AdmInfo.Age);	
			$('#txtPapmiNo').text(AdmInfo.PapmiNo);
			$('#txtMrNo').text(AdmInfo.MrNo);
			$('#txtAdmDate').text(AdmInfo.AdmDate);
			$('#txtDisDate').text(AdmInfo.DischDate);
			if (AdmInfo.IsDeath=='1'){
				$('#txtPatName').css('color','red');	// 死亡病人
			}
			
			$('#txtAdmitDiag').val(AdmInfo.AdmitDiag);
			$('#txtMainDiag').val(AdmInfo.MainDiag);
			$('#txtOtherDiag').val(AdmInfo.OtherDiag);
		}
		
		$('#txtAdmitDiag').hover(function(){
			var AdmitDiag = $('#txtAdmitDiag').val();
			if (AdmitDiag!='') {
				$("#txtAdmitDiag").popover({
					content:AdmitDiag,
					trigger:'hover',
					placement:'bottom-right'
				});
				$("#txtAdmitDiag").popover('show'); 
			}			
		});
		$('#txtMainDiag').hover(function(){
			var MainDiag = $('#txtMainDiag').val();
			if (MainDiag!='') {
				$("#txtMainDiag").popover({
					content:MainDiag,
					trigger:'hover',
					placement:'bottom-right'
				});
				$("#txtMainDiag").popover('show'); 
			}			
		});
		
		$('#txtOtherDiag').hover(function(){
			var OtherDiag = $('#txtOtherDiag').val();
			if (OtherDiag!='') {
				$("#txtOtherDiag").popover({
					content:OtherDiag,
					trigger:'hover',
					placement:'bottom-right'
				});
				$("#txtOtherDiag").popover('show'); 
			}			
		});
	}
    
   //展示报告信息
	obj.ReportInfo = function(aOpsID,aAnaesID){	
	    //先清除赋值
		obj.ClearItem();
        if (aOpsID != "") {    //已填写手术信息表 
        	var objRepInfo = $m({
	            ClassName: "DHCHAI.IRS.INFOPSSrv",
	            MethodName: "GetOPSRepID",
	            aEpisodeDr:EpisodeDr,
	            aOPSID: aOpsID
	        }, false);
			if (!objRepInfo) return;
	        $('#txtRepDate').val(objRepInfo.split("^")[1]+" "+objRepInfo.split("^")[6]);
	        $('#txtRepLoc').val(objRepInfo.split("^")[9]);
	        $('#txtRepUser').val(objRepInfo.split("^")[3]);
	        $('#txtRepStatus').val(objRepInfo.split("^")[5]);
	        obj.ReportID    = objRepInfo.split("^")[0];
	        obj.RepStatus   = objRepInfo.split("^")[7];
			obj.ReportDate  = objRepInfo.split("^")[1];
			obj.ReportTime  = objRepInfo.split("^")[6]
			obj.RepLocID    = objRepInfo.split("^")[8];
			obj.RepUserID   = objRepInfo.split("^")[2];
			var  IsInfAnti  = objRepInfo.split("^")[10];
			if (IsInfAnti) {
				$HUI.radio("#radInfAnti-"+IsInfAnti).setValue(true);
				if (IsInfAnti==1) {
					$('#divINFAnti').removeAttr("style");
				}
			}
            var objInfo = $m({
                ClassName: "DHCHAI.IRS.INFOPSSrv",
                MethodName: "GetReportString",
                aRepID: aOpsID
            }, false);
			if (!objInfo) return;
	
            $("#txtOperDesc").val(objInfo.split("^")[3]);           //手术名称
            $("#txtSttDateTime").datetimebox('setValue',objInfo.split("^")[4]);        //手术开始时间
            $("#txtEndDateTime").datetimebox('setValue',objInfo.split("^")[5]);        //手术结束时间
            $("#txtOpertorName").val(objInfo.split("^")[6]);        //手术医生

            $('#cboOperType').combobox('setValue', objInfo.split("^")[7].split(",")[0]);    //手术类型
            $('#cboOperType').combobox('setText', objInfo.split("^")[7].split(",")[1]);
			$("#txtOperCat").val(objInfo.split("^")[30]);           //手术分类
            $("#txtORWBC").val(objInfo.split("^")[16]);             //外周WBC

            $('#cboAnesMethod').combobox('setValue', objInfo.split("^")[8].split(",")[0]);  //麻醉方式
            $('#cboAnesMethod').combobox('setText', objInfo.split("^")[8].split(",")[1]);

            $('#cboIncisionE').combobox('setValue', objInfo.split("^")[10].split(",")[0]);  //切口等级
            $('#cboIncisionE').combobox('setText', objInfo.split("^")[10].split(",")[1]);

            $('#cboHealing').combobox('setValue', objInfo.split("^")[11].split(",")[0]);    //愈合情况
            $('#cboHealing').combobox('setText', objInfo.split("^")[11].split(",")[1]);

            $("#txtInciNum").val(objInfo.split("^")[17]);       //切口个数
            $("#txtBloodLoss").val(objInfo.split("^")[21]);     //失血量
            $("#txtBloodTrans").val(objInfo.split("^")[22]);    //输血量

            $('#cboNNISLevel').combobox('setValue', objInfo.split("^")[9].split(",")[0]);   //NNIS分级
            $('#cboNNISLevel').combobox('setText', objInfo.split("^")[9].split(",")[1]);

            var IsActive = objInfo.split("^")[20];              //是否术前抗生素
            if (IsActive == "1") {
                $('#chkAntiFlag').checkbox('setValue', true);
            }
            else {
                $('#chkAntiFlag').checkbox('setValue', false);
            }
            var IsActive = objInfo.split("^")[18];                  //是否使用窥镜
            if (IsActive == "1") {
                $('#chkSightGlass').checkbox('setValue', true);
            }
            else {
                $('#chkSightGlass').checkbox('setValue', false);
            }
            var IsActive = objInfo.split("^")[19];                  //是否植入物
            if (IsActive == "1") {
                $('#chkImplants').checkbox('setValue', true);
            }
            else {
                $('#chkImplants').checkbox('setValue', false);
            }

            $('#cboASAScore').combobox('setValue', objInfo.split("^")[12].split(",")[0]);   //ASA评分
            $('#cboASAScore').combobox('setText', objInfo.split("^")[12].split(",")[1]);

            $('#cboInfPos').combobox('setValue', objInfo.split("^")[13].split(",")[0]);     //手术部位
            $('#cboInfPos').combobox('setText', objInfo.split("^")[13].split(",")[1]);

            var IsActive = objInfo.split("^")[15];                  //是否院感
            if (IsActive == "1") {
                $('#chkInHospInf').checkbox('setValue', true);
            }
            else {
                $('#chkInHospInf').checkbox('setValue', false);
            }
            var IsActive = objInfo.split("^")[14];                  //切口感染
            if (IsActive == "1") {
                $('#chkIsOperInf').checkbox('setValue', true);
            }
            else {
                $('#chkIsOperInf').checkbox('setValue', false);

                $('#cboInfPos').combobox('disable');
            }
           
            var OperCompList = objInfo.split("^")[23];          //术后并发症
            if (OperCompList != "") {
                for (var indx = 0; indx < OperCompList.split(",").length; indx++) {
                    var OperComp = OperCompList.split(",")[indx];
                    if (OperComp == "") continue;
                    $("#chkOperComp" + OperComp).checkbox('setValue', true);
                }
            }
			
			$('#txtVisitName').val(objInfo.split("^")[24]);		//回访人员
			$('#dtVistDate').datebox('setValue', objInfo.split("^")[25]);		//回访日期
			$('#cboVisitResult').combobox('setValue', objInfo.split("^")[26].split(",")[0]);  //回访结果
            $('#cboVisitResult').combobox('setText', objInfo.split("^")[26].split(",")[1]);
			$('#txtVisitResume').val(objInfo.split("^")[27]);		//备注
			$('#txtPatTel').val(objInfo.split("^")[28]);			//患者联系电话
			if (objInfo.split("^")[29]) {
				obj.OperLocID = objInfo.split("^")[29];                 //update 20210709 在手术切口调查查询界面提交导致手术科室字典清空问题处理
			}else {
				 //手术查询
				var OprData = $m({
					ClassName: "DHCHAI.DPS.OROperAnaesSrv",
					MethodName: "GetOperData",
					aOperAnaesID: aAnaesID
				}, false);
				if (!OprData) return;
				obj.OperLocID = OprData.split("^")[28];
			}
			
        } else { 
         
            obj.ReportID    = "";
	        obj.RepStatus   = "";
			obj.ReportDate  = "";
			obj.ReportTime  = "";
			obj.RepLocID    = $.LOGON.LOCID;
			obj.RepUserID   = $.LOGON.USERID;		   
            //手术查询
            var OprData = $m({
                ClassName: "DHCHAI.DPS.OROperAnaesSrv",
                MethodName: "GetOperData",
                aOperAnaesID: obj.OperAnaesID
            }, false);
			if (!OprData) return;
            obj.OperLocID = OprData.split("^")[28];
            
            $("#txtOperDesc").val(OprData.split("^")[0]);           //手术名称
            $("#txtOpertorName").val(OprData.split("^")[1]);        //手术医生
            $("#txtSttDateTime").datetimebox('setValue',OprData.split("^")[2] + " " + OprData.split("^")[3]);  //开始时间
            
            $("#txtEndDateTime").datetimebox('setValue',OprData.split("^")[4] + " "+ OprData.split("^")[5]);  //结束时间
            if((OprData.split("^")[4]=="")&&(OprData.split("^")[5]=="")){
	            $("#txtEndDateTime").datetimebox('setValue',"");
	        }
            $('#cboOperType').combobox('setValue', OprData.split("^")[6]);      //手术类型
            $('#cboOperType').combobox('setText', OprData.split("^")[7]);       
			$("#txtOperCat").val(OprData.split("^")[31]);           //手术分类
			 
            $("#txtORWBC").val(OprData.split("^")[18]);     //外周WBC

            $('#cboAnesMethod').combobox('setValue', OprData.split("^")[8]);    //麻醉方式
            $('#cboAnesMethod').combobox('setText', OprData.split("^")[9]);

            $('#cboIncisionE').combobox('setValue', OprData.split("^")[10]);    //切口等级
            $('#cboIncisionE').combobox('setText', OprData.split("^")[11]);

            $('#cboHealing').combobox('setValue', OprData.split("^")[12]);      //愈合情况
            $('#cboHealing').combobox('setText', OprData.split("^")[13]);
                
            $("#txtInciNum").val(OprData.split("^")[19]);   //切口个数
            $("#txtBloodLoss").val(OprData.split("^")[20]);     //出血量
            $("#txtBloodTrans").val(OprData.split("^")[21]);    //输血量

            $('#cboNNISLevel').combobox('setValue', OprData.split("^")[16]);    //NNIS分级
            $('#cboNNISLevel').combobox('setText', OprData.split("^")[17]);

            $('#chkAntiFlag').checkbox('setValue', false);          //术前用药

            var IsActive = OprData.split("^")[22];      //使用窥镜
            if (IsActive == "1") {
                $('#chkSightGlass').checkbox('setValue', true);
            }
            else {
                $('#chkSightGlass').checkbox('setValue', false);
            }
            var IsActive = OprData.split("^")[23];      //植入物
            if (IsActive == "1") {
                $('#chkImplants').checkbox('setValue', true);
            }
            else {
                $('#chkImplants').checkbox('setValue', false);
            }
            $('#cboASAScore').combobox('setValue', OprData.split("^")[14]);     //ASA评分
            $('#cboASAScore').combobox('setText', OprData.split("^")[15]);

            $('#cboInfPos').combobox('setValue', OprData.split("^")[26]);   //手术部位
            $('#cboInfPos').combobox('setText', OprData.split("^")[27]);

            var IsActive = OprData.split("^")[24];          //是否院感
            if (IsActive == "1") {
                $('#chkInHospInf').checkbox('setValue', true);
            }
            else {
                $('#chkInHospInf').checkbox('setValue', false);
            }
            var IsActive = OprData.split("^")[25];          //切口感染
            if (IsActive == "1") {
                $('#chkIsOperInf').checkbox('setValue', true);
            }else {
                $('#chkIsOperInf').checkbox('setValue', false);
                $('#cboInfPos').combobox('clear');
                $('#cboInfPos').combobox('disable');
            }
        }
        //初始化抗菌药物信息
        obj.refreshgridINFAnti();
        //初始化按钮
        obj.InitButtons(obj.RepStatus);
    }
     //清理控件
    obj.ClearItem = function () {
	    $('#txtRepDate').val('');
        $('#txtRepLoc').val('');
        $('#txtRepUser').val('');
        $('#txtRepStatus').val('');

	    $("#txtOperDesc").val('');              //手术名称
	    $("#txtSttDateTime").datetimebox('clear');        //手术开始时间
	    $("#txtEndDateTime").datetimebox('clear');        //手术结束时间
	    $("#txtOpertorName").val('');           //手术医生	    
	    $('#cboOperType').combobox('clear');    //手术类型
	    $('#cboAnesMethod').combobox('clear');  //麻醉方式
	    $('#cboIncisionE').combobox('clear');   //切口等级
	    $('#cboHealing').combobox('clear');     //愈合情况
		$("#txtORWBC").val('');                 //外周WBC
	    $("#txtInciNum").val('');               //切口个数
	    $("#txtBloodLoss").val('');             //失血量
	    $("#txtBloodTrans").val('');            //输血量
	    $('#cboNNISLevel').combobox('clear');            //NNIS分级
	    $('#chkAntiFlag').checkbox('setValue', false);   //术前口服抗生素 
	    $('#chkSightGlass').checkbox('setValue', false); //使用窥镜
	    $('#chkImplants').checkbox('setValue', false);   //是否植入物
	    $('#cboASAScore').combobox('clear');             //ASA评分
	    $('#cboInfPos').combobox('clear');               //手术部位
		$('#chkInHospInf').checkbox('setValue', false);   //是否院感
		$('#chkIsOperInf').checkbox('setValue', false);   //切口感染
		$HUI.checkbox('input[type=checkbox][name=chkOperComp]').uncheck();   //术后并发症
		$('#txtVisitName').val('');		           //回访人员
		$('#dtVistDate').datebox('clear');		   //回访日期
		$('#cboVisitResult').combobox('clear');    //回访结果
		$('#txtVisitResume').val('');		       //备注
		$('#txtPatTel').val('');			       //患者联系电话
    }
    
    
    //加载按钮权限
    obj.InitButtons = function (RepStatus) {
	    $('#btnSave').hide();
	    $('#btnSubmit').hide();
		$('#btnCheck').hide();
		$('#btnDelete').hide();
		$('#btnPrint').hide();
		$('#btnUnCheck').hide();
	    
        switch (RepStatus) {
	        case '1':       // 保存
	       		$('#btnSave').show();
	       		$('#btnSaveFollow').hide();
				$('#btnSubmit').show();
				$('#btnDelete').show();
				break;
			case '2':       // 提交
				$('#btnSubmit').show();
				$('#btnSubmit').linkbutton({text:'提交'});
				$('#btnPrint').show();
				$('#btnSaveFollow').hide();
				$('#btnDelete').show();
				if (Admin==1){	// 管理员
					$('#btnCheck').show();
				}
				break;
			case '3':       // 审核
			$('#btnSaveFollow').show();
				$('#btnPrint').show();
				if (Admin==1){	// 管理员
					$('#btnUnCheck').show();
				}
				break;
			case '6':       // 取消审核
				$('#btnSaveFollow').hide();
				$('#btnSubmit').show();
				$('#btnDelete').show();
				if (Admin==1){	// 管理员
					$('#btnCheck').show();
				}
				break;
			case '4':       // 删除
				$('#btnSave').hide();
				$('#btnSaveFollow').hide();
			    $('#btnSubmit').show();
				$('#btnSubmit').linkbutton({text:'重新提交'});
				break;
			default:
				$('#btnSave').show();
				$('#btnSubmit').show();
				$('#btnSaveFollow').hide();
				break;
        }
    }

    //勾选是否感染
    $HUI.checkbox("[name='chkIsOperInf']", {
        onChecked: function (e, value) {
            $('#cboInfPos').combobox('enable');
        },
        onUnchecked: function (e, value) {
            $('#cboInfPos').combobox('clear');
            $('#cboInfPos').combobox('disable');
        }
    });
    //保存
    $('#btnSave').on('click', function () {
	    if(obj.Layer_Check()){
			var ret = obj.Layer_Save("1");
        	if (parseInt(ret) > 0) {
	        	obj.OpsID = ret;
            	obj.ReportInfo(obj.OpsID,obj.OperAnaesID);
           		$.messager.alert("提示", "保存成功!", 'info');
            	return;
        	}
        	else {
            	$.messager.alert("提示", "保存失败!", 'info');
            	return;
       	 	}
		}
    });
    //提交
    $('#btnSubmit').on('click', function () {
	    if(obj.Layer_Check()){
			var ret = obj.Layer_Save("2");
        	if (parseInt(ret) > 0) {
	        	obj.OpsID = ret;
            	obj.ReportInfo(obj.OpsID,obj.OperAnaesID);
           	 	$.messager.alert("提示", "提交成功!", 'info');
            	return;
        	}
        	else {
            	$.messager.alert("提示", "提交失败!", 'info');
            	return false;
        	}
		}
    });
    //审核
    $('#btnCheck').on('click', function () {
	    if(obj.Layer_Check()){
			var ret = obj.Layer_Save("3");
        	if (parseInt(ret) > 0) {
	        	obj.InitButtons("3");
	        	$('#txtRepStatus').val("审核");
            	$.messager.alert("提示", "审核成功!", 'info');
            	return;
        	}
        	else {
            	$.messager.alert("提示", "审核失败!", 'info');
            	return;
        	}
		}
    });
    //删除
    $('#btnDelete').on('click', function () {
	    if(obj.Layer_Check()){
			var ret = obj.Layer_Save("4");
        	if (parseInt(ret) > 0) {
	        	obj.InitButtons("4");
	        	$('#txtRepStatus').val("删除");
            	$.messager.alert("提示", "删除成功!", 'info');
            	return;
        	}
        	else {
            	$.messager.alert("提示", "删除失败!", 'info');
            	return;
        	}
		}
    });
     //取消审核
    $('#btnUnCheck').on('click', function () {
	    if(obj.Layer_Check()){
			var ret = obj.Layer_Save("6");
        	if (parseInt(ret) > 0) {
	        	obj.InitButtons("6");
	        	$('#txtRepStatus').val("取消审核");
            	$.messager.alert("提示", "取消审核成功!", 'info');
            	return;
        	}
        	else {
           	 	$.messager.alert("提示", "取消审核失败!", 'info');
            	return;
        	}
		}
    });
        //保存回访
     $('#btnSaveFollow').on('click', function () {
	    if(obj.Layer_Check()){
		    var INFOPSID = obj.OpsID;  
			var ret = obj.followSave();
        	if (parseInt(ret)> 0) {
            	obj.ReportInfo(INFOPSID,obj.OperAnaesID);
           	 	$.messager.alert("提示", "保存成功!", 'info');
            	return;
        	}
        	else {
            	$.messager.alert("提示", "保存失败!", 'info');
            	return false;
        	}
		}
    });
    //打印
    $('#btnPrint').on('click', function () {
        var fileName="DHCHAIINFOPS.raq&aReportID="+obj.ReportID+"&aEpisodeID="+EpisodeDr;
		DHCCPM_RQPrint(fileName);
		
		//var fileName="{DHCHAIINFOPS.raq(aReportID="+obj.ReportID+";aEpisodeID="+EpisodeDr+")}";
		//DHCCPM_RQDirectPrint(fileName);
    });
    
    //关闭
    $('#btnClose').on('click', function () {
		if (PageType!= 'WinOpen') {
			websys_showModal('close');
			closeWin();	   //消息弹出报告后无法关闭问题	
		}else {
			window.close();
		}
    });
    function closeWin(){
		var modal=findThisModal();
		if (modal && modal.length>0){
			modal.window('close');
		}else{
			window.close()
			if (parent && parent.closeTransWin) {
				parent.closeTransWin();
			}else if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			}
		}
	}
	function findThisModal(id){
		var modal=null;
		var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
		if (!window.parent || window.parent===window) return modal;
		try {
			var P$=window.parent.$;
		}catch(e){
			return modal;
		}
		if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
		window._findThisModalKey=key;
		
		P$('iframe').each(function(){
			try {
				if (this.contentWindow._findThisModalKey==key){
					modal=P$(this).closest('.window-body');
					return false;
				}
			}catch(e){}
			
		})
		return modal;
	}
    //数据格式验证
    obj.Layer_Check=function(){
		//电话号码格式过滤
		//14781717369
		var PatTem=$('#txtPatTel').val();	//患者电话号码
		var isMblNum=/^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1}))+\d{8})$/; 
  		var isPhNum=/^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
  		if((PatTem!="")&&!isMblNum.test(PatTem) && !isPhNum.test(PatTem)){
      	 	$.messager.alert("提示", "请正确填写手机号或固话号", 'info');
       		return false;
     	}
     	var IsInfAnti = Common_RadioValue('radInfAnti');
     	obj.InputAnti = obj.ANT_Save();				// 抗菌药物
     	if ((IsInfAnti==1)&&(!obj.InputAnti)){
	        $.messager.alert("提示", '存在与手术相关的抗菌用药信息，请填写抗菌用药信息内容！', 'info');
			return false;
        }
        if (IsInfAnti==""){
	        $.messager.alert("提示", '请勾选是否存在与手术相关的抗菌用药信息！', 'info');
			return false;
        }
     	return true;
	}
	//回放保存
    obj.followSave = function () {
        var INFOPSID = obj.OpsID;  										// 手术切口调查表ID
        //回访信息
		var VisitName=$('#txtVisitName').val();							//回访人员
		var VistDate=$('#dtVistDate').datebox('getValue');				//回访日期
		var VisitResul = $('#cboVisitResult').combobox('getValue');     // 切口等级
		var VisitResume=$('#txtVisitResume').val();						//备注
		var PatTem=$('#txtPatTel').val();
		var InputRep = INFOPSID; 										//患者电话号码
		 	InputRep +="^" + VisitName;
		 	InputRep +="^" + VistDate;
		 	InputRep +="^" + VisitResul;
		 	InputRep +="^" + VisitResume;
			InputRep +="^" + PatTem;
		var flg = $m({
            ClassName: "DHCHAI.IRS.INFOPSSrv",
            MethodName: "SaveINFOPSFollow",
            aInputStr: InputRep
        }, false);
        return flg;
		 
	}
    //保存
    obj.Layer_Save = function (Status) {
        var ReportID = obj.ReportID;               // 报告ID
        var INFOPSID = obj.OpsID;                  // 手术切口调查表ID
        var EpisodeDR = EpisodeDr;                 // 就诊记录
        var IRRepType = "4";                       // 手术切口调查表类型
        var IRRepDate = obj.ReportDate;            // 报告日期
        var IRRepTime = obj.ReportTime;            // 报告时间
        var IRRepLocDr = obj.RepLocID;             // 报告科室
        var IRRepUser = obj.RepUserID;             // 报告人
        var IRStatusDr = Status;                   // 报告状态 非ID
        var IRLinkDiags = "";                      // 感染诊断
        var IRLinkICDs = "";                       // 疾病诊断
        var IRLinkLabs = "";                       // 病原学送检
        var IRLinkAntis = "";                      // 抗菌用药
        var IRLinkOPSs = INFOPSID;                 // 手术信息
        var IRLinkMRBs = "";                       // 多耐信息
        var IRLinkInvOpers = "";                   // 侵害性操作
        var IRLinkICUUCs = "";                     // ICU导尿管
        var IRLinkICUVAPs = "";                    // ICU呼吸机
        var IRLinkICUPICCs = "";                   // ICU中心静脉
        var IRDiagnosisBasis = "";                 // 诊断依据
        var IRDiseaseCourse = "";                  // 感染性疾病病程
        var IRInLocDr = "";                        // 入科来源
        var IROutLocDr = "";                       // 出科去向
        var IRInDate = "";                         // 入科时间
        var IROutDate = "";                        // 出科时间 
        var IRAPACHEScore = "";                    // APACHEⅡ评分
        var IROutIntubats = "";                    // 转出ICU带管情况
        var IROut48Intubats = "";                  // 转出ICU48带管情况

        var AnaesID = obj.OperAnaesID;              // 手术记录ID
        var OperLocDR = obj.OperLocID;              // 手术科室
        var OperDxDr = "";                          // 标准手术ID

        var OperDesc = $("#txtOperDesc").val();                          // 手术名称
        var SttDateTime = $("#txtSttDateTime").datetimebox('getValue');  // 开始日期时间
        SttDateTime = SttDateTime.replace(" ", "")
        var StartDate = SttDateTime.substring(0, 10);                     // 开始日期
        var StartTime = SttDateTime.substring(10, 15);                    // 开始时间
        var EndDateTime = $("#txtEndDateTime").datetimebox('getValue');   // 结束日期时间
        EndDateTime = EndDateTime.replace(" ", "")
        var EndDate = EndDateTime.substring(0, 10);                    // 结束日期
        var EndTime = EndDateTime.substring(10, 15);                   // 结束时间
        var OpertorName = $("#txtOpertorName").val();                  // 手术医生
        var OperTypeDR = $('#cboOperType').combobox('getValue');       // 手术类型
        var AnesMethodDR = $('#cboAnesMethod').combobox('getValue');   // 麻醉方式
        var IncisionDR = $('#cboIncisionE').combobox('getValue');      // 切口等级
        var HealingDR = $('#cboHealing').combobox('getValue');         // 愈合情况
        var NNISLevelDR = $('#cboNNISLevel').combobox('getValue');     // NNIS分级
        var ASAScoreDR = $('#cboASAScore').combobox('getValue');       // ASA评分
        var InfPosDR = $('#cboInfPos').combobox('getValue');           // 感染部位
        var ORWBC = $("#txtORWBC").val();                              // 术前外周WBC
        var InciNum = $("#txtInciNum").val();                          // 切口个数
        var BloodLoss = $("#txtBloodLoss").val();                      // 失血量
        var BloodTrans = $("#txtBloodTrans").val();                    // 输血量
        var AntiFlag = $('#chkAntiFlag').checkbox('getValue') ? '1' : '0';      // 术前口服抗生素
        var SightGlass = $('#chkSightGlass').checkbox('getValue') ? '1' : '0';  // 是否使用窥镜
        var Implants = $('#chkImplants').checkbox('getValue') ? '1' : '0';      // 植入物
        var InHospInf = $('#chkInHospInf').checkbox('getValue') ? '1' : '0';    // 是否引起院感
        var IsOperInf = $('#chkIsOperInf').checkbox('getValue') ? '1' : '0';    // 切口感染
        var OperCompList = Common_CheckboxValue('chkOperComp');
        var IsInfAnti = Common_RadioValue('radInfAnti');   

		//回访信息
		var VisitName=$('#txtVisitName').val();							//回访人员
		var VistDate=$('#dtVistDate').datebox('getValue');				//回访日期
		var VisitResul = $('#cboVisitResult').combobox('getValue');     // 切口等级
		var VisitResume=$('#txtVisitResume').val();						//备注
		var PatTem=$('#txtPatTel').val();								//患者电话号码
		
        // 报告信息
        var InputRepStr = ReportID;     // 报告ID DHCHAI.IR.INFReport	
        InputRepStr += "^" + EpisodeDR;
        InputRepStr += "^" + IRRepType;
        InputRepStr += "^" + IRRepDate;
        InputRepStr += "^" + IRRepTime;  //5
        InputRepStr += "^" + IRRepLocDr;
        InputRepStr += "^" + IRRepUser;
        InputRepStr += "^" + IRStatusDr;
        InputRepStr += "^" + IRLinkDiags;
        InputRepStr += "^" + IRLinkICDs;  //10
        InputRepStr += "^" + IRLinkLabs;
        InputRepStr += "^" + IRLinkAntis;
        InputRepStr += "^" + IRLinkOPSs;
        InputRepStr += "^" + IRLinkMRBs;
        InputRepStr += "^" + IRLinkInvOpers;   //15
        InputRepStr += "^" + IRLinkICUUCs;
        InputRepStr += "^" + IRLinkICUVAPs;
        InputRepStr += "^" + IRLinkICUPICCs;
        InputRepStr += "^" + IRDiagnosisBasis;
        InputRepStr += "^" + IRDiseaseCourse;  //20
        InputRepStr += "^" + IRInLocDr;
        InputRepStr += "^" + IRInDate;
        InputRepStr += "^" + IROutDate;
        InputRepStr += "^" + IRAPACHEScore;
        InputRepStr += "^" + IROutIntubats;   //25
        InputRepStr += "^" + IROut48Intubats;
        InputRepStr += "^" + IsInfAnti;

        // 手术切口调查报告信息
        var InputOPSStr = INFOPSID;
        InputOPSStr += "^" + EpisodeDR;
        InputOPSStr += "^" + AnaesID;
        InputOPSStr += "^" + OperLocDR;
        InputOPSStr += "^" + OperDesc;
        InputOPSStr += "^" + OperDxDr;
        InputOPSStr += "^" + StartDate;
        InputOPSStr += "^" + EndDate;
        InputOPSStr += "^" + StartTime;
        InputOPSStr += "^" + EndTime;
        InputOPSStr += "^" + "";         // 手术时长
        InputOPSStr += "^" + OpertorName;
        InputOPSStr += "^" + "";         //手术医生DR
        InputOPSStr += "^" + OperTypeDR;
        InputOPSStr += "^" + AnesMethodDR;
        InputOPSStr += "^" + NNISLevelDR;
        InputOPSStr += "^" + IncisionDR;
        InputOPSStr += "^" + HealingDR;
        InputOPSStr += "^" + IsOperInf;
        InputOPSStr += "^" + InfPosDR;
        InputOPSStr += "^" + InHospInf;
        InputOPSStr += "^" + ASAScoreDR;
        InputOPSStr += "^" + ORWBC;
        InputOPSStr += "^" + InciNum;
        InputOPSStr += "^" + SightGlass;
        InputOPSStr += "^" + Implants;
        InputOPSStr += "^" + AntiFlag;
        InputOPSStr += "^" + BloodLoss;
        InputOPSStr += "^" + BloodTrans;
        InputOPSStr += "^" + OperCompList;
        InputOPSStr += "^" + "";   // 更新日期
        InputOPSStr += "^" + "";   // 更新时间
        InputOPSStr += "^" + $.LOGON.USERID;
		InputOPSStr += "^" + VisitName;
		InputOPSStr += "^" + VistDate;
		InputOPSStr += "^" + VisitResul;
		InputOPSStr += "^" + VisitResume;
		InputOPSStr += "^" + PatTem;
        // 日志信息
        var InputLogStr = "";            // DHCHAI.IR.INFReport-->ID
        InputLogStr += "^" + Status;     // 状态
        InputLogStr += "^" + "";         // 操作意见
        InputLogStr += "^" + $.LOGON.USERID;

        // 抗菌药物信息
        var InputAnti = obj.ANT_Save();

        var InputStr = InputOPSStr + "#" + InputRepStr + "#" + InputLogStr + "#" + InputAnti;
        var flg = $m({
            ClassName: "DHCHAI.IRS.INFOPSSrv",
            MethodName: "SaveINFOPS",
            aInputStr: InputStr
        }, false);
        return flg;
    }
    
    obj.AntiRowID = ''; //抗菌用药选中行
    obj.AntiUseID = '';
    obj.refreshgridINFAnti = function () {
        // 抗菌用药信息
        obj.gridINFAnti = $HUI.datagrid("#gridINFAnti", {
            //title: '抗菌用药',
            headerCls: 'panel-header-gray',
            iconCls: 'icon-paper',
            rownumbers: true, //如果为true, 则显示一个行号列
            singleSelect: true,
            nowrap: false,
            autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
            loadMsg: '数据加载中...',
            columns: [[
                { field: 'AntiDesc', title: '抗生素', width: 140 },
                { field: 'SttDate', title: '开始日期', width: 90 ,
                    formatter:function(value,row,index){
                        if(('SttTime' in row)&&(row.SttTime)!=""){
                            return value+" "+row.SttTime
                        }else{
                            return value  
                        }
	                }
	             },
                { field: 'EndDate', title: '结束日期', width: 90 , 
                    formatter:function(value,row,index){
                        if(('EndTime' in row)&&(row.EndTime)!=""){
                            return value+" "+row.EndTime
                        }else{
                            return value  
                        }
	                }
                },
                { field: 'DoseQty', title: '剂量', width: 45 },
                { field: 'DoseUnit', title: $g('剂量<br>单位'), width: 45 },
                { field: 'PhcFreq', title: '频次', width: 100 },
                { field: 'MedUsePurpose', title: '用途', width: 80 },
                { field: 'AdminRoute', title: '给药途径', width: 80 },
                { field: 'MedPurpose', title: '目的', width: 60 },
                { field: 'TreatmentMode', title: $g('治疗用药<br>方式'), width: 75 },
                { field: 'PreMedEffect', title: $g('预防用药<br>效果'), width: 75 },
                { field: 'PreMedIndicat', title: $g('预防用药<br>指征'), width: 70 },
                { field: 'CombinedMed', title: '联合用药', width: 75 },
                { field: 'PreMedTime', title: $g('术前用药<br>时间(分钟)'), width: 75 },
                { field: 'PostMedDays', title: $g('术后用药<br>天数'), width: 65 },
                { field: 'SenAna', title: '敏感度', width: 55 }
            ]],
            onSelect: function (rindex, rowData) {
                if (obj.AntiRowID === rindex) {
                    obj.AntiRowID = "";
                    $("#btnINFAntiDel").linkbutton("disable");
                    obj.gridINFAnti.clearSelections();  //清除选中行
                } else {
                    obj.AntiRowID = rindex;
                    $("#btnINFAntiDel").linkbutton("enable");
                }
            },
            onDblClickRow: function (rindex, rowdata) {
                if (rindex > -1) {
                    OpenINFAntiEdit(rowdata, rindex);
                }
            },
            onLoadSuccess: function (data) {
                $("#btnINFAntiDel").linkbutton("disable");
            }
        });
		//修改 ReportID  =》obj.ReportID  
        if (obj.ReportID) {
            $cm({
                ClassName: "DHCHAI.IRS.INFAntiSrv",
                QueryName: "QryINFAntiByRep",
                aReportID: obj.ReportID
            }, function (rs) {
                $('#gridINFAnti').datagrid('loadData', rs);
            });
        }
    }
    //obj.refreshgridINFAnti();

    // 抗菌用药提取事件
    $('#btnINFAntiSync').click(function (e) {
        /// TODO同步医嘱
        /* $m({
             ClassName: "DHCHAI.DI.DHS.SyncHisInfo",
             MethodName: "SyncAdmOEOrdItem",
             aSCode: HISCode,
             aEpisodeIDX: EpisodeIDx,
             aDateFrom: ServiceDate,
             aDateTo: ServiceDate
         });*/
        OpenINFAntiSync();
    });
    //抗菌用药提取弹出事件
    obj.LayerOpenINFAntiSync = function () {
        $HUI.dialog('#LayerOpenINFAntiSync', {
            title: "抗菌用药-提取 [双击数据进行编辑]",
            iconCls: 'icon-w-paper',
            width: 1200,
            height: 500,
            modal: true,
            shadow: true,
            isTopZindex: true
        });
    }
    // 弹出抗菌用药提取框
    function OpenINFAntiSync() {
        refreshgridINFAntiSync();
        $('#LayerOpenINFAntiSync').show();
        obj.LayerOpenINFAntiSync();
    }
    //抗菌用药列表
    function refreshgridINFAntiSync() {
        obj.gridINFAntiSync = $HUI.datagrid("#gridINFAntiSync", {
            fit: true,
            headerCls: 'panel-header-gray',
            iconCls: 'icon-paper',
            rownumbers: true, //如果为true, 则显示一个行号列
            singleSelect: true,
            autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
            loadMsg: '数据加载中...',
            url: $URL,
            queryParams: {
                ClassName: 'DHCHAI.IRS.INFAntiSrv',
                QueryName: 'QryINFAntiByRep',
                aEpisodeID: EpisodeDr
            },
            columns: [[
                { field: 'AntiDesc', title: '医嘱名称', width: 300 },
                { field: 'SttDate', title: '开始日期', width: 120 },
                { field: 'EndDate', title: '结束日期', width: 120 },
                { field: 'DoseQty', title: '剂量', width: 100 },
                { field: 'DoseUnit', title: '剂量单位', width: 100 },
                { field: 'PhcFreq', title: '频次', width: 120 },
                { field: 'AdminRoute', title: '给药途径', width: 120 },
                { field: 'MedPurpose', title: '使用目的', width: 150 }
            ]],
            onDblClickRow: function (rindex, rowdata) {
                if (rindex > -1) {
                    OpenINFAntiEdit(rowdata, '');
                    $HUI.dialog('#LayerOpenINFAntiSync').close();
                }
            }
        });
    }

    // 添加 抗菌用药事件
    $("#btnINFAntiAdd").click(function (e) {
        OpenINFAntiEdit('', '');
    });

    // 弹出抗菌用药弹框
    function OpenINFAntiEdit(d, r) {
        $('#LayerOpenINFAntiEdit').show();
        obj.LayerOpenINFAntiEdit();
        $HUI.dialog('#LayerOpenINFAntiEdit', {
            buttons: [{
                text: '保存',
                handler: function () {
                    INFAntiAdd(d, r);
                }
            }, {
                text: '取消',
                handler: function () { $HUI.dialog('#LayerOpenINFAntiEdit').close(); }
            }]
        });
        InitINFAntiEditData(d);
    }

    // 抗菌用药弹框
    obj.LayerOpenINFAntiEdit = function () {
        $HUI.dialog('#LayerOpenINFAntiEdit', {
            title: '抗菌用药-编辑',
            iconCls: 'icon-w-paper',
            width: 775,
            modal: true,
            shadow: true,
            isTopZindex: true
        });
    }

    // 抗菌用药编辑框信息初始化
    function InitINFAntiEditData(d) {
        obj.cboAnti = $HUI.lookup("#cboAnti", {
            panelWidth: 450,
            url: $URL,
            editable: true,
            mode: 'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
            isValid: true,
            pagination: true,
            loadMsg: '正在查询',
            isCombo: true,             //是否输入字符即触发事件，进行搜索
            minQueryLen: 1,             //isCombo为true时，可以搜索要求的字符最小长度
            valueField: 'ID',
            textField: 'BTAnitDesc',
            queryParams: { ClassName: 'DHCHAI.DPS.OEAntiMastMapSrv', QueryName: 'QryOEAntiMastMap' },
            columns: [[
                { field: 'BTAnitDesc', title: '抗菌用药名称', width: 400 }
            ]],
            onBeforeLoad: function (param) {
                var desc = param['q'];
                //if (desc=="") return false;  
                param = $.extend(param, { aAlias: desc }); //将参数q转换为类中的参数
            },
            onSelect: function (index, rowData) {
                obj.AntiUseID = rowData['ID'];
            }
        });

        obj.cboDoseUnit = Common_ComboDicID("cboDoseUnit", "OEDoseUnit");
        obj.cboPhcFreq = Common_ComboDicID("cboPhcFreq", "OEPhcFreq");
        obj.cboMedUsePurpose = Common_ComboDicID("cboMedUsePurpose", "AntiMedUsePurpose");
        obj.cboAdminRoute = Common_ComboDicID("cboAdminRoute", "AntiAdminRoute");
        obj.cboMedPurpose = Common_ComboDicID("cboMedPurpose", "AntiMedPurpose");
        obj.cboTreatmentMode = Common_ComboDicID("cboTreatmentMode", "AntiTreatmentMode");
        obj.cboPreMedEffect = Common_ComboDicID("cboPreMedEffect", "AntiPreMedEffect");
        obj.cboPreMedIndicat = Common_ComboDicID("cboPreMedIndicat", "AntiPreMedIndicat");
        obj.cboCombinedMed = Common_ComboDicID("cboCombinedMed", "AntiCombinedMed");
        obj.cboSenAna = Common_ComboDicID("cboSenAna", "LABTestRstSen");

        // 控件赋值
        if (d) {
            obj.AntiUseID = d.AntiUseID;
            $('#cboAnti').lookup('setText', d.AntiDesc);
            $('#txtDoseQty').val(d.DoseQty);
            $('#cboDoseUnit').combobox('setValue', d.DoseUnitID);
            $('#cboDoseUnit').combobox('setText', d.DoseUnit);
            $('#cboPhcFreq').combobox('setValue', d.PhcFreqID);
            $('#cboPhcFreq').combobox('setText', d.PhcFreq);
            $('#cboMedUsePurpose').combobox('setValue', d.MedUsePurposeID);
            $('#cboMedUsePurpose').combobox('setText', d.MedUsePurpose);
            $('#cboAdminRoute').combobox('setValue', d.AdminRouteID);
            $('#cboAdminRoute').combobox('setText', d.AdminRoute);
            $('#cboMedPurpose').combobox('setValue', d.MedPurposeID);
            $('#cboMedPurpose').combobox('setText', d.MedPurpose);
            $('#cboTreatmentMode').combobox('setValue', d.TreatmentModeID);
            $('#cboTreatmentMode').combobox('setText', d.TreatmentMode);
            $('#cboPreMedEffect').combobox('setValue', d.PreMedEffectID);
            $('#cboPreMedEffect').combobox('setText', d.PreMedEffect);
            $('#cboPreMedIndicat').combobox('setValue', d.PreMedIndicatID);
            $('#cboPreMedIndicat').combobox('setText', d.PreMedIndicat);
            $('#cboCombinedMed').combobox('setValue', d.CombinedMedID);
            $('#cboCombinedMed').combobox('setText', d.CombinedMed);
            $('#cboSenAna').combobox('setValue', d.SenAnaID);
            $('#cboSenAna').combobox('setText', d.SenAna);
            $('#txtPreMedTime').val(d.PreMedTime);
            $('#txtPostMedDays').val(d.PostMedDays);
            $('#txtSttDate').datetimebox('setValue', d.SttDate+" "+d.SttTime);
            if (d.EndDate){
	            $('#txtEndDate').datetimebox('setValue', d.EndDate+" "+d.EndTime);
			}         

        } else {
            $('#cboAnti').lookup('setText', '');
            $('#txtDoseQty').val('');
            $('#cboDoseUnit').combobox('clear');
            $('#cboPhcFreq').combobox('clear');
            $('#cboMedUsePurpose').combobox('clear');
            $('#cboAdminRoute').combobox('clear');
            $('#cboMedPurpose').combobox('clear');
            $('#cboTreatmentMode').combobox('clear');
            $('#cboPreMedEffect').combobox('clear');
            $('#cboPreMedIndicat').combobox('clear');
            $('#cboCombinedMed').combobox('clear');
            $('#cboSenAna').combobox('clear');
            $('#txtPreMedTime').val('');
            $('#txtPostMedDays').val('');
            $('#txtSttDate').datebox('clear');
            $('#txtEndDate').datebox('clear');
        }
    }

    // 添加抗菌用药信息到列表
    function INFAntiAdd(d, r) {
        var NowDate = Common_GetDate(new Date());

        var ID = '';
        var AntiUseID = obj.AntiUseID;
        var AntiDesc2 = '';
        if (d) {
            ID = d.ID;
            AntiUseID = d.AntiUseID;
            AntiDesc2 = d.AntiDesc2;
        }
        var AntiDesc = $('#cboAnti').lookup('getText');
        var DoseQty = $('#txtDoseQty').val();
        var DoseUnitID = $('#cboDoseUnit').combobox('getValue');
        if (DoseUnitID == '') {
            var DoseUnit = '';
        } else {
            var DoseUnit = $('#cboDoseUnit').combobox('getText');
        }
        var PhcFreqID = $('#cboPhcFreq').combobox('getValue');
        if (PhcFreqID == '') {
            var PhcFreq = '';
        } else {
            var PhcFreq = $('#cboPhcFreq').combobox('getText');
        }
        var MedUsePurposeID = $('#cboMedUsePurpose').combobox('getValue');
        if (MedUsePurposeID == '') {
            var MedUsePurpose = '';
        } else {
            var MedUsePurpose = $('#cboMedUsePurpose').combobox('getText');
        }
        var AdminRouteID = $('#cboAdminRoute').combobox('getValue');
        if (AdminRouteID == '') {
            var AdminRoute = '';
        } else {
            var AdminRoute = $('#cboAdminRoute').combobox('getText');
        }
        var MedPurposeID = $('#cboMedPurpose').combobox('getValue');
        if (MedPurposeID == '') {
            var MedPurpose = '';
        } else {
            var MedPurpose = $('#cboMedPurpose').combobox('getText');
        }
        var TreatmentModeID = $('#cboTreatmentMode').combobox('getValue');
        if (TreatmentModeID == '') {
            var TreatmentMode = '';
        } else {
            var TreatmentMode = $('#cboTreatmentMode').combobox('getText');
        }
        var PreMedEffectID = $('#cboPreMedEffect').combobox('getValue');
        if (PreMedEffectID == '') {
            var PreMedEffect = '';
        } else {
            var PreMedEffect = $('#cboPreMedEffect').combobox('getText');
        }
        var PreMedIndicatID = $('#cboPreMedIndicat').combobox('getValue');
        if (PreMedIndicatID == '') {
            var PreMedIndicat = '';
        } else {
            var PreMedIndicat = $('#cboPreMedIndicat').combobox('getText');
        }
        var CombinedMedID = $('#cboCombinedMed').combobox('getValue');
        if (CombinedMedID == '') {
            var CombinedMed = '';
        } else {
            var CombinedMed = $('#cboCombinedMed').combobox('getText');
        }
        var SttDate = $('#txtSttDate').datebox('getValue');
        var EndDate = $('#txtEndDate').datebox('getValue');
        var PreMedTime = $('#txtPreMedTime').val();
        var PostMedDays = $('#txtPostMedDays').val();
        var SenAnaID = $('#cboSenAna').combobox('getValue');
        if (SenAnaID == '') {
            var SenAna = '';
        } else {
            var SenAna = $('#cboSenAna').combobox('getText');
        }

        var errinfo = "";
        MedUsePurpose
        if (obj.AntiUseID == '') {
            errinfo = errinfo + "请选择标准抗菌用药医嘱!<br>";
        }
        if (DoseQty == '') {
            errinfo = errinfo + "剂量不能为空!<br>";
        }
        if (MedUsePurpose == '') {
            errinfo = errinfo + "用途不能为空!<br>";
        }
        if (DoseUnitID == '') {
            errinfo = errinfo + "剂量单位为空或字典未对照!<br>";
        }
        if (PhcFreqID == '') {
            errinfo = errinfo + "频次为空或字典未对照!<br>";
        }
        if (AdminRouteID == '') {
            errinfo = errinfo + "给药途径为空或字典未对照!<br>";
        }
        if (MedPurposeID == '') {
            errinfo = errinfo + "目的为空或字典未对照!<br>";
        } else {
            if (MedPurpose == "预防") {
                if (PreMedEffectID == '') {
                    errinfo = errinfo + "目的为预防时,预防用药效果不能为空!<br>";
                }
                if (PreMedIndicatID == '') {
                    errinfo = errinfo + "目的为预防时,预防用药指征不能为空!<br>";
                }
            }
            if ((MedPurpose.indexOf("预防") >= 0) && (MedPurpose.indexOf("治疗") >= 0)) {
                if (TreatmentModeID == '') {
                    errinfo = errinfo + "目的为治疗+预防时,治疗用药方式不能为空!<br>";
                }
                if (PreMedEffectID == '') {
                    errinfo = errinfo + "目的为治疗+预防时,预防用药效果不能为空!<br>";
                }
                if (PreMedIndicatID == '') {
                    errinfo = errinfo + "目的为治疗+预防时,预防用药指征不能为空!<br>";
                }
            }

            if (MedPurpose == "治疗") {
                if (TreatmentModeID == '') {
                    errinfo = errinfo + "目的为治疗时,治疗用药方式不能为空!<br>";
                }
            }
        }

        if (CombinedMedID == '') {
            errinfo = errinfo + "联合用药不能为空!<br>";
        }
        if (SttDate == '') {
            errinfo = errinfo + "开始日期不能为空!<br>";
        }
        if (Common_CompareDate(SttDate, NowDate) > 0) {
            errinfo = errinfo + "开始时间不能在当前时间之后!<br>";
        }
        if (EndDate != '') {
            if (Common_CompareDate(SttDate, EndDate) > 0) {
                errinfo = errinfo + "结束日期不能在开始日期之前!<br>";
            }
        }

        if (errinfo != '') {
            $.messager.alert("提示", errinfo, 'info');
            return;
        }

        var row = {
            ID: ID,
            EpisodeID: EpisodeDr,
            ReportID: obj.ReportID,
            AntiUseID: AntiUseID,
            AntiDesc: AntiDesc,
            AntiDesc2: AntiDesc2,
            SttDate: SttDate,
            EndDate: EndDate,
            DoseQty: DoseQty,
            DoseUnitID: DoseUnitID,
            DoseUnit: DoseUnit,
            PhcFreqID: PhcFreqID,
            PhcFreq: PhcFreq,
            MedUsePurposeID: MedUsePurposeID,
            MedUsePurpose: MedUsePurpose,
            AdminRouteID: AdminRouteID,
            AdminRoute: AdminRoute,
            MedPurposeID: MedPurposeID,
            MedPurpose: MedPurpose,
            TreatmentModeID: TreatmentModeID,
            TreatmentMode: TreatmentMode,
            PreMedEffectID: PreMedEffectID,
            PreMedEffect: PreMedEffect,
            PreMedIndicatID: PreMedIndicatID,
            PreMedIndicat: PreMedIndicat,
            CombinedMedID: CombinedMedID,
            CombinedMed: CombinedMed,
            PreMedTime: PreMedTime,
            PostMedDays: PostMedDays,
            SenAnaID: SenAnaID,
            SenAna: SenAna,
            UpdateDate: '',
            UpdateTime: '',
            UpdateUserID: $.LOGON.USERID,
            UpdateUser: ''
        }

        // 数据重复标志
        var dataRepeatFlg = 0;
        for (var i = 0; i < obj.gridINFAnti.getRows().length; i++) {
            //r 为行号
            if ((parseInt(r) > -1) && (r == i)) {
                continue;
            }

            if ((AntiDesc == obj.gridINFAnti.getRows()[i].AntiDesc) && (SttDate == obj.gridINFAnti.getRows()[i].SttDate)) {
                dataRepeatFlg = 1;
            }
        }
        if (dataRepeatFlg == 1) {
            $.messager.confirm("提示", "存在开始日期、抗生素相同的记录,是否添加抗生素信息？", function (t) {
                if (t) {
                    if (parseInt(r) > -1) {  //修改
                        obj.gridINFAnti.updateRow({  //更新指定行
                            index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                            row: row
                        });
                    } else {	//添加
                        obj.gridINFAnti.appendRow({  //插入一个新行
                            ID: ID,
                            EpisodeID: EpisodeDr,
                            ReportID: obj.ReportID,
                            AntiUseID: AntiUseID,
                            AntiDesc: AntiDesc,
                            AntiDesc2: AntiDesc2,
                            SttDate: SttDate,
                            EndDate: EndDate,
                            DoseQty: DoseQty,
                            DoseUnitID: DoseUnitID,
                            DoseUnit: DoseUnit,
                            PhcFreqID: PhcFreqID,
                            PhcFreq: PhcFreq,
                            MedUsePurposeID: MedUsePurposeID,
                            MedUsePurpose: MedUsePurpose,
                            AdminRouteID: AdminRouteID,
                            AdminRoute: AdminRoute,
                            MedPurposeID: MedPurposeID,
                            MedPurpose: MedPurpose,
                            TreatmentModeID: TreatmentModeID,
                            TreatmentMode: TreatmentMode,
                            PreMedEffectID: PreMedEffectID,
                            PreMedEffect: PreMedEffect,
                            PreMedIndicatID: PreMedIndicatID,
                            PreMedIndicat: PreMedIndicat,
                            CombinedMedID: CombinedMedID,
                            CombinedMed: CombinedMed,
                            PreMedTime: PreMedTime,
                            PostMedDays: PostMedDays,
                            SenAnaID: SenAnaID,
                            SenAna: SenAna,
                            UpdateDate: '',
                            UpdateTime: '',
                            UpdateUserID: $.LOGON.USERID,
                            UpdateUser: ''
                        });
                    }
                    $HUI.dialog('#LayerOpenINFAntiEdit').close();
                }
            });
        } else {
            if (parseInt(r) > -1) {  //修改
                obj.gridINFAnti.updateRow({  //更新指定行
                    index: r,	   // index：要插入的行索引，如果该索引值未定义，则追加新行。row：行数据。
                    row: row
                });
            } else {	//添加
                obj.gridINFAnti.appendRow({  //插入一个新行
                    ID: ID,
                    EpisodeID: EpisodeDr,
                    ReportID: obj.ReportID,
                    AntiUseID: AntiUseID,
                    AntiDesc: AntiDesc,
                    AntiDesc2: AntiDesc2,
                    SttDate: SttDate,
                    EndDate: EndDate,
                    DoseQty: DoseQty,
                    DoseUnitID: DoseUnitID,
                    DoseUnit: DoseUnit,
                    PhcFreqID: PhcFreqID,
                    PhcFreq: PhcFreq,
                    MedUsePurposeID: MedUsePurposeID,
                    MedUsePurpose: MedUsePurpose,
                    AdminRouteID: AdminRouteID,
                    AdminRoute: AdminRoute,
                    MedPurposeID: MedPurposeID,
                    MedPurpose: MedPurpose,
                    TreatmentModeID: TreatmentModeID,
                    TreatmentMode: TreatmentMode,
                    PreMedEffectID: PreMedEffectID,
                    PreMedEffect: PreMedEffect,
                    PreMedIndicatID: PreMedIndicatID,
                    PreMedIndicat: PreMedIndicat,
                    CombinedMedID: CombinedMedID,
                    CombinedMed: CombinedMed,
                    PreMedTime: PreMedTime,
                    PostMedDays: PostMedDays,
                    SenAnaID: SenAnaID,
                    SenAna: SenAna,
                    UpdateDate: '',
                    UpdateTime: '',
                    UpdateUserID: $.LOGON.USERID,
                    UpdateUser: ''
                });
            }
            $HUI.dialog('#LayerOpenINFAntiEdit').close();
        };
    }

    // 删除抗菌用药信息事件
    $("#btnINFAntiDel").click(function (e) {
        var selectObj = obj.gridINFAnti.getSelected();
        var index = obj.gridINFAnti.getRowIndex(selectObj);  //获取当前选中行的行号(从0开始)
        if (!selectObj) {
            $.messager.alert("提示", "请选择一行要删除的抗菌用药数据!", 'info');
            return;
        } else {
            $.messager.confirm("提示", "是否要删除抗菌用药：" + selectObj.AntiDesc + " ?", function (r) {
                if (r) {
                    obj.gridINFAnti.deleteRow(index);
                }
            });
        }
    });

    obj.ANT_Save = function () {
        // 抗菌用药
        var InputAnti = '';
        for (var i = 0; i < obj.gridINFAnti.getRows().length; i++) {
            var Input = obj.gridINFAnti.getRows()[i].ID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].EpisodeID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiUseID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiDesc;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AntiDesc2;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].SttDate+(('SttTime' in obj.gridINFAnti.getRows()[i])?(' '+obj.gridINFAnti.getRows()[i].SttTime):'');
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].EndDate+(('EndTime' in obj.gridINFAnti.getRows()[i])?(' '+obj.gridINFAnti.getRows()[i].EndTime):'');
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].DoseQty;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].DoseUnitID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PhcFreqID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].MedUsePurposeID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].AdminRouteID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].MedPurposeID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].TreatmentModeID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedEffectID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedIndicatID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].CombinedMedID;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PreMedTime;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].PostMedDays;
            Input = Input + CHR_1 + obj.gridINFAnti.getRows()[i].SenAnaID;
            Input = Input + CHR_1 + '';
            Input = Input + CHR_1 + '';
            Input = Input + CHR_1 + $.LOGON.USERID;
            InputAnti = InputAnti + CHR_2 + Input;
        }
        if (InputAnti) InputAnti = InputAnti.substring(1, InputAnti.length);
        return InputAnti;
    }
	//点击摘要
    $('#btnAbstractMsg').click(function(){
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeDr+'&PageType=WinOpen';
	   
	   //window.open样式打开[宽:95%,高：95%]
		var Width=window.screen.availWidth*0.95;
		var Height=window.screen.availHeight*0.95;
		var Top = (window.screen.availHeight - Height-30) / 2; 			//获得窗口的垂直位置 
        var Left = (window.screen.availWidth - Width-10) / 2; 			//获得窗口的水平位置
		 //--打开摘要
		var page=websys_createWindow(strUrl,"",'height='+Height+',innerHeight='+Height+',width='+Width+',innerWidth='+Width+',top='+Top+',left='+Left+',status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no'); 
	});
}

