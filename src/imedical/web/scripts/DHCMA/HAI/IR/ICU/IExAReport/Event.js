//三管感染防控督查表[Event]
function InitIExARepWinEvent(obj) {
	//获取单元格里面的内容
	//1.督察-复选框,2.督察人/日期-文本框,3.督察结果-✔/✖
    obj.GetCellRet = function (DicType,value,index,ItemID) {
	    if(DicType=="督查"){
			return '<input class="hisui-checkbox" id="ckIP_' + ItemID + '"type="checkbox" name="Assert" value="0">';
		}
		else if(DicType=="督查人"){
			return '<span id="txtIPUser_' + ItemID + '"style="user-select: none; " >' + value + '</span>';
		}
	    else if(DicType=="督查日期"){
			return '<span id="txtIPDate_' + ItemID + '"style="user-select: none; " >' + value + '</span>';
		}
		else{
			var ret = "";
			if (value == "1") ret = "✔";
        	if (value == "-1") ret = "✖";
        	if (value == "0") ret = "";
        	return '<span id="txtIPRes_' + index+"_"+ItemID + '"style="user-select: none; " >' + ret + '</span>';
		}
    }
    //刷新督查表内容
    //1.刷新报告,2.刷新列名(按配置)
    obj.refreshgridIntuRep = function () {
	   	//刷新报告
	   	$("#gridIntuRep").datagrid("loading");
		var Ret = $cm({
			ClassName: "DHCHAI.IRS.ICUIExASrv",
            QueryName: "QryIExARep",
            aIExAID: obj.IExAID,
            aTubeType:obj.TubeType,
            aPageID:obj.Page,
            aPrintType:obj.IsEdit,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridIntuRep').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
       	
       	var StaDay=1;
       	if(obj.TubeType=="PICC")var StaDay=obj.PICCStaDay;
       	if(obj.TubeType=="VAP")var StaDay=obj.VAPStaDay;
       	if(obj.TubeType=="UC")var StaDay=obj.UCStaDay;
       	
       	for (var i = 1; i <= 15; i++) {
	       	var ID="Item"+i;
			//置管天数
			var TubeDay=parseInt([15*(obj.Page-1)+(i-1)])+parseInt(StaDay);	
	        //刷新列名(按配置)	
			var bcolumn = $('#gridIntuRep').datagrid('getColumnOption',ID);
            bcolumn.title = '第'+TubeDay+'天';
   	 	} 
    }   
    
    obj.LoadEvent = function () {
	    //是否允许'修正报告'
	    if(obj.IsEdit=="0"){
		    $('#txtIntuDate').datebox('disable');
		    $('#txtExtuDate').datebox('disable');
		    $("#btnUpdate").linkbutton('disable');
		}
		
	    //加载数据
        var Data = $m({
            ClassName: "DHCHAI.IRS.ICUIExASrv",
            MethodName: "GetIExAInfo",
            aIExAID: obj.IExAID
        }, false)
        var PatData = Data.split("#")[0];		//患者基本信息
        var TubeType = Data.split("#")[1];		//插管基本信息
        var IExAData = Data.split("#")[2];		//报告基本信息
        
        //初始化头链接
        obj.Paadm = PatData.split("^")[0];      //患者就诊号
        obj.TubeType = TubeType;                 //导管类型(PICC/VAP/UC)
        
        //初始化患者基本信息
        var PatName = PatData.split("^")[1];
        var Sex = PatData.split("^")[2];
        var Age = PatData.split("^")[3];
        var PapmiNo = PatData.split("^")[4];
        var MrNo = PatData.split("^")[5];
        var AdmDate = PatData.split("^")[6];
        var AdmWardDesc = PatData.split("^")[7];
        var DischDate = PatData.split("^")[8];
        var DischWardDesc = PatData.split("^")[9];
        var Diag = PatData.split("^")[10];
        if (Sex == '女') {
            $('#ImgSex').removeClass('man').addClass('woman');
        } else if (Sex == '男') {
            $('#ImgSex').removeClass('woman').addClass('man');
        } else {
            $('#ImgSex').removeClass('woman').removeClass('man').addClass('ukgender');
        }
        $('#txtName').text(PatName);
        $('#txtSex').text(Sex);
        $('#txtAge').text(Age);
        $('#txtPapmiNo').text(PapmiNo);
        $('#txtMrNo').text(MrNo);
        $('#txtAdmDate').text(AdmDate);
        $('#txtAdmWard').text(AdmWardDesc);
        $('#txtDisDate').text(DischDate);
        $('#txtDisWard').text(DischWardDesc);
        $('#txtAdmitDiag').val(Diag);
        
        obj.Paadm = PatData.split("^")[0];      //保存'患者就诊号'
        obj.DischDate=DischDate;				//保存'患者出院日期'
       
        //患者各类督查表数目
		var RepCount = $m({
            ClassName: "DHCHAI.IRS.ICUIExASrv",
            MethodName: "GetIExARepCount",
            aEpisodeID: obj.Paadm
        }, false)
        var PICCCount = RepCount.split("^")[0];
        var VAPount = RepCount.split("^")[1];
        var UCCCount = RepCount.split("^")[2];
        if (PICCCount == 0) $('#tipPICC').hide();
        if (VAPount == 0) $('#tipVAP').hide();
        if (UCCCount == 0) $('#tipUC').hide();
        $('#tipPICC').html("" + PICCCount);			//静脉插管数目
        $('#tipVAP').html("" + VAPount);			//呼吸机数目
        $('#tipUC').html("" + UCCCount);  			//导尿管数目
        
        //初始化插管基本信息
        obj.TubeType=TubeType;					//保存插管类别
        if (obj.TubeType == "PICC") {
	        $('#txtTitle').html("血管导管相关血流感染防控督查表");
	        	
            $('#txtMainDiag').val("血管导管督查表");
            $('#txtMainDiag').css('color', 'red');
            $('#txtMainDiag').css('font-weight', 'bold');
        }
        if (obj.TubeType == "VAP") {
	        $('#txtTitle').html("呼吸机相关肺炎感染防控督查表");
	        
            $('#txtMainDiag').val("呼吸机督查表");
            $('#txtMainDiag').css('color', 'blue');
            $('#txtMainDiag').css('font-weight', 'bold');
        }
        if (obj.TubeType == "UC") {
	        $('#txtTitle').html("导尿管相关尿路感染防控督查表");
	        
            $('#txtMainDiag').val("导尿管督查表");
            $('#txtMainDiag').css('color', 'Orange');
            $('#txtMainDiag').css('font-weight', 'bold');
        }
        $HUI.combobox("#cboIntuType", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4, 
            valueField: 'ID',
            textField: 'Desc',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.IRS.ICUIExASrv';
                param.QueryName = 'QryDicList';
                param.aRepType = 1;
           	 	param.aTubeType = obj.TubeType;
            	param.aItemCode = "TubeType";
            	param.aIExAID = "";
                param.ResultSetType = 'array';
            },
            onLoadSuccess:function(data){
	            if((obj.IsAdmin=="1")&&(obj.IsEdit=="0")){				//院感科只读模式
		        	$('#cboIntuType').combobox('disable');
		        }
			}
        });
        //初始化报告基本信息
        var IntuTypID = IExAData.split("^")[0];
        $('#cboIntuType').combobox('select', IntuTypID);
        var IntuDate = IExAData.split("^")[2];
        $('#txtIntuDate').datebox('setValue', IntuDate);
        var ExtuDate = IExAData.split("^")[3];
        $('#txtExtuDate').datebox('setValue', ExtuDate);
        obj.IntuDate = IntuDate;                	//保存插管日期
        obj.ExtuDate = ExtuDate;                	//保存拔管日期
        
        //初始化留置原因
        obj.RefreshRetReason(obj.IExAID, obj.TubeType);
        //初始化表格
        obj.IADays = IExAData.split("^")[4];		//插管天数
        obj.InfList = IExAData.split("^")[5];		//感染列表
        obj.Page = IExAData.split("^")[6];       //当前页
		obj.ALLPage = obj.Page;

        obj.refreshgridIntuRep();
    }
    
    //初始化留置原因
    obj.RefreshRetReason = function (IExAID, TubeType) {
        $('#RetReason').empty();
        //加载留置原因
        var RetReason = $cm({
            ClassName: "DHCHAI.IRS.ICUIExASrv",
            QueryName: "QryDicList",
            aRepType:1,
            aTubeType:TubeType,
            aItemCode:"RetReason",
            aIExAID: IExAID
        }, false);
        if (RetReason.total == 0){
	        $('#DivReason').hide();
        }
        else {
            $('#DivReason').show();
            
            var html = '<table><tr><td>留置原因:</td>';
            for (var i = 0; i < RetReason.total; i++) {
                var Reason = RetReason.rows[i];

                var ID = Reason.ID;
                var Code = Reason.Code;
                var Desc = Reason.Desc;
                
                var txtDisable="";
                if(obj.IsEdit=="0")txtDisable='disabled=""';
            
                var IsCheck = Reason.IsCheck;
                if (IsCheck == 1) {
                    var html = html + '<td><input class="hisui-checkbox" type="checkbox" name="RetReason" checked="checked" id="' + ID + '" value="' + ID + '"'+txtDisable+'>' + Desc + '</td>'
                }
                else {
                    var html = html + '<td><input class="hisui-checkbox" type="checkbox" name="RetReason" id="' + ID + '" value="' + ID + '"'+txtDisable+'>' + Desc + '</td>'
                }
            }
            var html = html + '</tr></table>';
            $('#RetReason').append(html);
        }
        //留置原因勾选改变事件
        $HUI.checkbox("[name='RetReason']", {
			onCheckChange: function () {
          		obj.SaveIExA();    
			}
        }) 
    }
    //'更新'事件
    $('#btnUpdate').click(function (e) {
	    if(obj.ExtuDate!=""){
	    	$.messager.alert("提示", "患者已拔管,不允许修改!", 'info');
        	return;
	    }
	    var IntuTypeDesc = $('#cboIntuType').combobox('getText');
        var IntuDate = $('#txtIntuDate').combobox('getValue');     //插管日期
        var ExtuDate = $('#txtExtuDate').combobox('getValue');     //拔管日期
        
        $.messager.confirm("提示", '插管类型:<font color="red">' + IntuTypeDesc + '</font><br>插管日期:<font color="red">' + IntuDate + '</font><br>拔管日期:<font color="red">' + ExtuDate + '</font><br>是否更新督查表?', function (r) {
			if (r) {
				var SubDay = DateDiff(IntuDate, ExtuDate);
                if (SubDay > 30) {
                    $.messager.alert("提示", "更新日期不能超过一个月！", 'info');
                    return;
                }
                //保存督查表
                var Ret = obj.SaveIExA();
                
                if (parseInt(Ret) > 0) {
                    $.messager.alert("提示", "更新成功!", 'info');
                } else {
                    $.messager.alert("提示", "更新失败!", 'info');
                }
            }
            else {
                return;
            }
        });
    })
    //'前一页'事件
    $('#btnPrior').click(function (e) {
        if (obj.Page <= 1){
	    	$.messager.alert("提示", "当前第一页", 'info');
	        return;  
        } 
        //刷新ICU插拔管督查表
        obj.Page = obj.Page - 1;
		obj.refreshgridIntuRep();
    });
    //'后一页'事件
    $('#btnNext').click(function (e) {
        if (obj.Page >= obj.ALLPage){
	    	$.messager.alert("提示", "当前最后一页", 'info');
	        return;  
	    }       
        //刷新ICU插拔管督查表
        obj.Page = obj.Page + 1;
		obj.refreshgridIntuRep();
    });
    //导出表点击事件
    $('#btnExport').click(function (e) {
        //润乾报表打印
        var url = "dhccpmrunqianreport.csp?reportName=DHCMA.HAI.IR.ICU.IExAReport.raq&aIExAID=" + obj.IExAID+ "&aTubeType=" + obj.TubeType + "&aPageID=" + obj.Page + "&aPrintType=" + 2;
        websys_createWindow(url, 1, "width=800,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
    });
	
    //静脉导管点击事件
    $('#btnPICC').click(function (e) {
	    obj.OpenLayerIExA('PICC');
    });
    //呼吸机点击事件
    $('#btnVAP').click(function (e) {
        obj.OpenLayerIExA('VAP');
    });
    //导尿管点击事件
    $('#btnUC').click(function (e) {
       obj.OpenLayerIExA('UC');
    });
    obj.OpenLayerIExA=function(TubeType){
	    obj.BuildTube=TubeType;				//保存打开界面插管类型
		$('#LayerIExA').show(); 			//显示界面
		var TubeDesc=""
		if(TubeType=="PICC") TubeDesc="<span style='color:red'>静脉插管</span>";
        if(TubeType=="VAP") TubeDesc="<span style='color:blue'>呼吸机</span>";
        if(TubeType=="UC") TubeDesc="<span style='color:#DAA520'>导尿管</span>";
        $HUI.dialog('#LayerIExA', {
     		title: "防控督查表("+TubeDesc+")[双击打开]",
       		iconCls: 'icon-w-paper',
           	width: 800,
            height: 400,
           	modal: true,
            isTopZindex: true
       	})
    	//初始化'插管类型'    	
        var DicList=$cm ({
			ClassName:"DHCHAI.IRS.ICUIExASrv",
			QueryName:"QryDicList",
			aRepType:1,				//ICU
			aTubeType:TubeType,
			aItemCode:"TubeType"	//插管类别
		},false);
        $HUI.combobox("#cboBuildType",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:DicList.rows
		});
        //初始化'插管日期'
        $('#txtBuildDate').datebox('setValue',"");
        	
        //刷新表
        obj.refreshGridIExAReport();
	}
     //刷新'患者''插拔管督查表'列表
	obj.refreshGridIExAReport=function(){
		var IsALL=Common_RadioValue("chkStatunit");
		
		$("#gridIExAReport").datagrid("loading"); 						//'加载中...'提示信息
		var Ret = $cm({
			ClassName: 'DHCHAI.IRS.ICUIExASrv',
			QueryName: 'QryIExARepList',
			aEpisodeID: obj.Paadm,
			aTubeType: obj.BuildTube,
			aIsALL:IsALL,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridIExAReport').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
	}
    //'显示全部'选中事件
	$HUI.radio("[name='chkStatunit']", {
       	 onCheckChange: function () {
           	obj.refreshGridIExAReport();
		}
	})
    //'三管医嘱'
    $('#OEItem').click(function (e) {
	    switch (obj.TubeType) {
            case "PICC": var Flag = 1; break;
            case "VAP": var Flag = 2; break;
            case "UC": var Flag = 3; break;
            default: var Flag = 0
        };
        $('#LayerHisOEOrdItem').show();
        $HUI.dialog('#LayerHisOEOrdItem', {
            title: "历史插管医嘱信息",
            iconCls: 'icon-w-paper',
            width: 700,
            height: 350,
            top: 185,
            modal: true,
            isTopZindex: true
        })
        
        obj.refreshgridHisOEOrdItem(Flag);  		//刷新历史医嘱
    });
    $('#btnINFLabSync').click(function (e) {
		switch (obj.BuildTube) {
            case "PICC": var Flag = 1; break;
            case "VAP": var Flag = 2; break;
            case "UC": var Flag = 3; break;
            default: var Flag = 0
        };
        $('#LayerHisOEOrdItem').show();
        $HUI.dialog('#LayerHisOEOrdItem', {
            title: "历史插管医嘱信息",
            iconCls: 'icon-w-paper',
            width: 700,
            height: 350,
            top: 185,
            modal: true,
            isTopZindex: true
        })
        
        obj.refreshgridHisOEOrdItem(Flag);  		//刷新历史医嘱
	})
    //刷新'三管医嘱'
    obj.refreshgridHisOEOrdItem = function (Flag) {
	    $("#gridHisOEOrdItem").datagrid("loading"); 						//'加载中...'提示信息
		var Ret = $cm({
			ClassName: 'DHCHAI.IRS.ICULogSrv',
			QueryName: 'QryICUAdmOeItem',
			aPaAdm: obj.Paadm,
			aFlag: Flag,
            page: 1,
            rows: 999
        }, function (rs) {
            $('#gridHisOEOrdItem').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
    }
    
    //'新增'按钮点击事件
    $('#btnBuild').click(function (e) {
        var IntuType = $('#cboBuildType').combobox('getValue');    //插管类型ID
        if (IntuType == "") {
            $.messager.alert("提示", "插管类型不能为空!", 'info');
            return;
        }
        var IntuDate = $('#txtBuildDate').combobox('getValue');    //置管日期
        var Flag=Common_CompareDate(IntuDate,Common_GetDate(new Date()));
        if(Flag=="-1"){
	    	$.messager.alert("提示", "置管日期不能为空!", 'info');
            return;
	    }
        if(Flag=="1") {
           $.messager.alert("提示", "置管日期不能大于当前日期!", 'info');
            return;
        }
	    
        var IntuTypeDesc = $('#cboBuildType').combobox('getText');
        $.messager.confirm("提示", '插管类型:<font color="red">' + IntuTypeDesc + '</font><br>插管日期:<font color="red">' + IntuDate + '</font><br>是否生成督查表?', function (r) {
            if (r) {
                var InputStr = "^" + obj.Paadm + "^" + IntuType + "^" + IntuDate + "^^^" + 1;
                var ret = $cm({
                    ClassName: "DHCHAI.IR.ICUIExA",
                    MethodName: "Update",
                    aInputStr: InputStr
                }, false);
                if (parseInt(ret) > 0) {
                    $.messager.alert("提示", "生成成功!", 'info');

                    obj.refreshGridIExAReport();      		//刷新列表
                } else {
                    $.messager.alert("提示", "生成失败!", 'info');
                }
            }
            else {
                return;
            }
        });
    })
    //删除表事件
    obj.DeleteIExA = function (iInputStr, iTubeType) {
        $.messager.confirm("提示", '确定删除/激活督查表?', function (r) {
            if (r) {
                var Ret = $cm({
                    ClassName: "DHCHAI.IR.ICUIExA",
                    MethodName: "Update",
                    aInputStr: iInputStr
                }, false);
                if (parseInt(Ret) > 0) {
                    $.messager.alert("提示", "删除/激活成功!", 'info');
                    obj.RefreshTip(obj.Paadm);       //刷新患者插拔管数目
                    obj.refreshGridIExARepList(iTubeType);
                } else {
                    $.messager.alert("提示", "删除/激活失败!", 'info');
                }
            }
            else {
                return;
            }
        });
    }
    //Part 执行方法
    //获取评估人,评估日期
    obj.GetUserMsg = function (iUserID, iIntuDate, iIntuDay) {
        var UserMsg = $m({
            ClassName: "DHCHAI.IRS.ICUIExASrv",
            MethodName: "GetUserMsg",
            aUserID: iUserID,
            aIntuDate: iIntuDate,
            aIntuDay: iIntuDay
        }, false);
        var User = UserMsg.split("^")[0];
        var NowDate = UserMsg.split("^")[1];
        return User + "^" + NowDate;
    }
    
    //历史插管医嘱信息弹出
    obj.LayerHisOEOrdItem = function () {
        $HUI.dialog('#LayerHisOEOrdItem', {
            title: "历史插管医嘱信息-提取<span style='color:red'> [双击数据进行提取]</span>",
            iconCls: 'icon-w-paper',
            width: 800,
            height: 400,
            top: 185,
            modal: true,
            isTopZindex: true
        })
    }
    
   
    
    //保存-更新插拔管督查表
    obj.SaveIExA = function () {
        //插管类型ID
        var IntuType = $('#cboIntuType').combobox('getValue');     
        if (IntuType == "") {
            $.messager.alert("提示", "插管类型不能为空!", 'info');
            return;
        }
        //插管日期
        var IntuDate = $('#txtIntuDate').combobox('getValue');     
        if (IntuDate == "") {
            $.messager.alert("提示", "置管日期不能为空!", 'info');
            return;
        }
        if ((obj.DischDate!="")&&(IntuDate>obj.DischDate)) {
            $.messager.alert("提示", "置管日期不能大于出院日期!", 'info');
            return;
        }
        //拔管日期
        var ExtuDate = $('#txtExtuDate').combobox('getValue'); 
        if ((ExtuDate != "") && (IntuDate > ExtuDate)) {
            $.messager.alert("提示", "置管日期不能大于拔管日期！", 'info');
            return;
        }
        var RetReason = Common_CheckboxValue('RetReason');          //留置原因
        
        var Instr = obj.IExAID;
        var Instr = Instr + "^" + obj.Paadm;
        var Instr = Instr + "^" + IntuType;
        var Instr = Instr + "^" + IntuDate;
        var Instr = Instr + "^" + ExtuDate;
        var Instr = Instr + "^" + RetReason;
        var Instr = Instr + "^" + 1;
        
        var ret = $cm({
            ClassName: "DHCHAI.IR.ICUIExA",
            MethodName: "Update",
            aInputStr: Instr
        }, false);
        return ret;
    }
    //保存插拔管评估明细表
    obj.SaveIExAExt = function (iInputStr) {
        var ret = $m({
            ClassName: "DHCHAI.IRS.ICUIExASrv",
            MethodName: "SaveIExAExt",
            aInputStr: iInputStr
        }, false);
        return ret;
    }
    //删除|激活
    obj.UpdateStatus=function(IExAID,IsActive){
	    if(IsActive=="1"){
			var txt="激活";
		}
		else{
			var txt="删除";
		}
	    $.messager.confirm("提示", '是否'+txt+'督查表?', function (r) {
        	if (r) {
                var ret = $m({
					ClassName: "DHCHAI.IR.ICUIExA",
					MethodName: "UpdateIsActive",
					aIExAID:IExAID,
					aIsActive:IsActive
				}, false);
				if (parseInt(ret) > 0) {
					$.messager.alert("提示", "操作成功!", 'info');
           			 obj.refreshGridIExAReport();
				} else {
					$.messager.alert("提示", "操作失败!", 'info');
				}
            }
            else {
                return;
            }
        });
	}
}


