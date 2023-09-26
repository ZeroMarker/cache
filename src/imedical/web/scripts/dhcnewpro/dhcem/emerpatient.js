/// Creator: nisijia
/// CreateDate: 2016-11-16

var RegQue="",ArrivedQue="",AllPatient=""   //用于查询留观，非留观等

$(document).ready(function () {

    //初始化时间
    initDate();

    //绑定事件
    initMethod();

    //初始化cobobox
    initCardCombo();

    //初始化表格
    initTable();

    //设置焦点位置
    $('#cardNo').focus();
    
    $('.selectpicker').selectpicker({  
         'selectedText': 'cat'  
     }); 
     
    myheight=$(window).height()-70,
    $('.emerPatient .left').css("height",myheight);  //hxy 左侧竖线自适应
   
});


function initCardCombo() {
    $('#Loc').selectpicker({
			noneSelectedText:"==请选择=="
        })
    runClassMethod("web.DHCEMPatCheckLevCom", "CardTypeDefineListBroker", {},
        function (data) {
            var carArr = []; //可以找到
            var objDefult = new Object();
            for (var i = 0; i < data.length; i++) {
                var obj = new Object();
                if (data[i].value.split("^")[8] == "N") {
                    obj.id = data[i].value;
                    obj.text = data[i].text;
                    carArr.push(obj);
                } else if (data[i].value.split("^")[8] == "Y") {
                    objDefult.id = data[i].value;
                    objDefult.text = data[i].text;
                    CarTypeSetting(objDefult.id);
                }
            }
            carArr.unshift(objDefult);

            $("#EmCardType").dhccSelect({
                data: carArr,
                minimumResultsForSearch: -1
            });
            $('#EmCardType').on('select2:select', function (evt) {
                CarTypeSetting(this.value);
            });
        });
	    $('#CheckLev').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMRegister&MethodName=GetNurLevel" ,
			minimumResultsForSearch:-1  
		});
}

function CarTypeSetting(value) {
    m_SelectCardTypeDR = value.split("^")[0];
    var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle") {
        $('#CardNo').attr("readOnly", false);
    } else {
        $('#CardNo').attr("readOnly", true);
    }
    $('#CardNo').val("");  /// 清空内容
}

//读卡
function readCardNo() {
    var myEquipDR = $('#EmCardType').val();
    //卡类型，"0^1^default.."
    var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			//卡有效
			var CardNo = myary[1];
			$('#CardNo').val(CardNo);
			CardPress();
			break;
		case "-200":
			//卡无效
			dhccBox.alert("提示","卡无效!");
			break;
		case "-201":
			//现金
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNo').val(CardNo);     /// 卡号
			$('#RegNo').val(PatientNo);   /// 登记号
			break;
		default:
	}
}

///  效验时间栏录入数据合法性 
function CheckDHCCTime(id) {
    var InTime = $('#' + id).val();
    if (InTime == "") {
        return "";
    }

    if (InTime.length < 4) {
        InTime = "0" + InTime;
    }
    if (InTime.length != 4) {
        dhccBox.alert("请录入正确的时间格式！例如:18:23,请录入1823", "register-three");
        return $('#' + id).val();
    }

    var hour = InTime.substring(0, 2);
    if (hour > 23) {
        //dhccBox.alert("我的message","classname");
		dhccBox.alert("小时数不能大于23！", "register-one");
        return $('#' + id).val();
    }

    var itme = InTime.substring(2, 4);
    if (itme > 59) {
        dhccBox.alert("分钟数不能大于59！", "register-one");
        return $('#' + id).val();
    }
    return hour + ":" + itme;
}

/// 获取焦点后时间栏设置 add 2016-09-23
function SetDHCCTime(id) {

    var InTime = $('#' + id).val();
    if (InTime == "") {
        return "";
    }
    InTime = InTime.replace(":", "");
    return InTime;
}
///查找按钮
function search() {
	//dhccBox.alert(RegQue+":"+ArrivedQue+":"+AllPatient);
	//将号别拼串
	var Loclist=$("#Loc").val();
	var dataList = [];
	var ArcDataList="";
	if(Loclist!=null){	
		for(var i=0;i<Loclist.length;i++)
		{	
			var tmp=Loclist[i];
			dataList.push(tmp);
		} 
		ArcDataList=dataList.join("$c(1)");
	}

	//定义留观，非留观，本科留观
    var isDiag = (arguments[0] == undefined) ? "" : arguments[0];
   
    $('#ccPatientTb').dhccQuery({
        query: {
            LocID: locId,
            UserID: LgUserID,
            IPAddress: "222.132.155.197",
            AllPatient: AllPatient,
            PatientNo:$("#RegNo").val(),
            SurName: "", 
            StartDate: $("#StartDate input").val(),
            EndDate: $('#EndDate input').val(),
            ArrivedQue: ArrivedQue,
            RegQue: RegQue,
            isDiag: isDiag,
            LocHao:ArcDataList,   //将选中号别传至后台
            HospID:hosp,
            GropID:LgGroupID  
        }
    })
}
//病人卡片
function setPanel(data) {

}

///初始化时间控件
function initDate() {
    //结束开始日期
    $('#EndDate').dhccDate();
    //$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))

    $('#StartDate').dhccDate();
    //$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
    runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 日期格式走配置
				function(data){
					if(data==3){
						$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
						$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))   
				    }else if(data==4){
					    $("#StartDate").setDate(new Date().Format("dd/MM/yyyy"));
					    $("#EndDate").setDate(new Date().Format("dd/MM/yyyy"));	
					}else{
						return;
					}
				});
}

//
function initMethod() {
	//再次分诊
    $("#upCheckLev").on('click', function () {
        var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
        if(checkedRows.length==0){
		 dhccBox.alert("请选择患者！","SelPat");
		 return false;
		 }
		var row = checkedRows[0];
		window.open ("dhcem.empatchecklev.csp?EpisodeID="+row.EpisodeID, "newwindow", "height=450, width=400, toolbar =no,top=100,left=500,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") 	
		return false;
    })
	
    //读卡
    $("#readCardNo").on('click', function () {
        readCardNo();
    })

    //查找按钮导出按钮 保存按钮
    $("#Find").on('click', function () {
        search();
    })
    //病人列表
    $("#patientList").on('click',function(){
	    ShowPatNum();
		$("#btnpatient span")[0].innerHTML="病人列表";
		RegQue="";
		ArrivedQue="";
		AllPatient="";
		search();
    })
    //留观
    $("#attention").on('click',function(){
	    HidePatNum();
		$("#btnpatient span")[0].innerHTML="留观";
		RegQue="";
		ArrivedQue="";
		AllPatient="on";
		search();
		
    })
    //本科留观
    $("#bttention").on('click',function(){
	    HidePatNum();
		$("#btnpatient span")[0].innerHTML="本科留观";
		RegQue="";
		ArrivedQue="on";
		AllPatient="";
		search(); 
		
    })
    //非留观
    $("#nattention").on('click',function(){
		HidePatNum();
		$("#btnpatient span")[0].innerHTML="非留观";
		RegQue="on";
		ArrivedQue="";
		AllPatient="";
		search(); 
    })
	//待诊
    $("#awaitDiag").on('click', function () {
        search("N");
    });
	//已诊
    $("#haveDiag").on('click', function () {
        search("Y"); 
    });
    //正在处理
    $("#nowDiag").on('click',function(){
	 	//search("Y"); 
    });
    //接诊
    $("#admissions").on('click',function(){
		var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
    	if(checkedRows.length==0){
		      dhccBox.alert("请选中一条记录","patRentList-three");
	              return;
	        }else{ 
	        var row=checkedRows[0]; 
        	var EpisodeID=row.EpisodeID
        	var patientId=row.PatientID      
	        window.location.href="dhcem.docmainoutpat.csp?EpisodeID="+EpisodeID
	        }
    });
    //分诊
    $("#triage").on('click',openCheckLev);
    //退号
    $("#backNumber").on('click',function(){	
    	var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
    	var row=checkedRows[0]; 
		var patname=row.PAPMIName;
        var EpisodeID=row.EpisodeID;
    	var backNumber=confirm("你确定要"+patname+"退号吗!");
	 	if(backNumber==true){
	 		runClassMethod("web.DHCDocOutPatientList","SetAllowReturn",{"EpisodeID":EpisodeID,"DoctorId":LgUserCode},function(jsonObj){
				if(jsonObj==0){
					dhccBox.alert("成功","Succ")
				}   	
     		});
   		 }else{
	 			return;   
   			 }
    });
	
    //登记号回车
    	$('#RegNo').on('keypress', function(e){   
        // 监听回车按键  
       e=e||event;
       if(e.keyCode=="13"){
	     if($('#RegNo').val()==""){
		 	dhccBox.alert("登记号为空","EmptyReg");    
		 	return
		 }
		var regNo = $('#RegNo').val(); 
		var m_lenght = ""
		
		///获取后台配置登记号长度
		runClassMethod("web.DHCCLCom","GetPatConfig",{},
			function(data){
				m_lenght=data.split("^")[0];
				},"text",false
		) 
		
		for (i=regNo.length;i<m_lenght;i++){
			regNo = "0"+regNo;
		}
			
		ClearPatNum();    
		
		PatInfoByReg(regNo);
       }    
	});
	   
    //卡号回车
    $('#CardNo').on('keypress', function (e) {
        e = e || event;
        if (e.keyCode == "13") {
	        CardPress();    
        }
    });
    
    //修改状态改变
    $('#upCheckLev .dropdown-menu li').on('click',UpPatStatus)

}

//待诊和已诊 NSJ 2017-02-09
function awaitDiagNum(data) {
	
    var awaitDiagNum = 0;
    var haveDiagNum = 0;
    var nowDiagNum=0
    for (i = 0; i < data.length; i++) {
        if(data[i].WalkStatus=="到达") {
            haveDiagNum++;   //已诊
        } else if(data[i].WalkStatus==""){
             //待诊
            awaitDiagNum++
        }/* else{
	        haveDiagNum++
        } */
		
    }
     $("#nowDiagNum")[0].innerHTML ="（"+nowDiagNum+"）";  //正在处理
     $("#awaitDiagNum")[0].innerHTML ="（"+awaitDiagNum+"）"; //待诊
     $("#haveDiagNum")[0].innerHTML ="（"+haveDiagNum+"）";  //已诊
}

function initTable() {
    var columns = [
    		{
    			checkbox: true,
    			title:'选择'
 			},
 			
    		{
                field: 'Num',
                title: '序号'
            },
            //{
            //    field: 'EpisodeID',
            //    title: '就诊ID'
            //},
            //{
            //    field: 'PatientID',
            //    title: '病人ID'
            //},
            {
                field: 'PAPMINO',
                title: '登记号'
            },
             {
                field: 'PAAdmPriority',
                align: 'center',
                title: '护士分级',
                formatter:updateFontColor
            },
            {
                field: 'PAPMIName',
                title: '姓名',formatter:FormatterName
            }, {
                field: 'PAPMISex',
                title: '性别'
            }, {
                field: 'PAPMIDOB',
                title: '出生日期'
            }, {
                field: 'PAPMIAge',
                title: '年龄'
            }, {
                field: 'PAAdmDocCodeDR',
                align: 'center',
                title: '医生'
            }, {
                field: 'WalkStatus',
                align: 'center',
                title: '状态'
            }, {
                field: 'PAAdmDate',
                align: 'center',
                title: '就诊日期'
            }, {
                field: 'PAAdmTime',
                align: 'center',
                title: '就诊时间'
            }, {
                field: 'PAAdmDepCodeDR',
                align: 'center',
                title: '就诊科室'
            }, {
                field: 'PAAdmReason',
                align: 'center',
                title: '病人类型'
            },{
                field: 'Diagnosis', 
                align: 'center',
                title: '诊断'
               
            },{
                field: 'RegDoctor',
                align: 'center',
                title: '号别'
            },
             {
                field: 'PAAdmWard',
                align: 'center',
                title: '病房'
            },
             {
                field: 'PAAdmBed',
                align: 'center',
                title: '床位号'
            },{
                field: 'LocSeqNo',
                align: 'center',
                title: '顺序号'
            }
        ]
    //表格
    $('#ccPatientTb').dhccTable({
        height: $(window).height()-163,//hxy 2017-02-21 去滚动条
        pageSize: 1000,
        pageList: [1000, 2000],
        singleSelect:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMEmeraPatient&MethodName=GetDataInfo',
        columns:columns,
        queryParam: {
            LocID: locId,
            UserID: LgUserID,
            IPAddress: "",
            AllPatient: "",
            PatientNo: "",
            SurName: "",
            StartDate: $("#StartDate input").val(),
            EndDate: $('#EndDate input').val(),
            ArrivedQue: "",
            RegQue: "",
            isDiag: "",
            HospID:hosp,
            GropID:LgGroupID
            
        },
        onLoadSuccess:function(data){
	        },
		onClickRow:function(row,$element,field){
			var frm=window.parent.document.forms["fEPRMENU"];	
			$("#EpisodeID").val(row.EpisodeID);
			$("#PatientID").val(row.PatientID);	
			if(frm.EpisodeID){
				frm.EpisodeID.value=row.EpisodeID;
				frm.PatientID.value=row.PatientID;	
			}
		}
    });
    function updateFontColor(value){
	    if(value==""){
		 	return '<span>'+value+'</span>';   
	    }
	    if(value.indexOf("1级")!="-1"){
		    return '<span style="color:red">'+value+'</span>';
		}
		if(value.indexOf("2级")!="-1"){
			return '<span style="color:red">'+value+'</span>';	
		}
		if(value.indexOf("3级")!="-1"){
			return '<span style="color:#f9bf3b">'+value+'</span>';	
		}
		if(value.indexOf("4级")!="-1"){
			return '<span style="color:green">'+value+'</span>';	
		}
	}
}

//设置Model模板数据    
function SettingModel(data){
	if(data.split("^").length=="1"){
	   switch(data){
		 case "-10":
		 	dhccBox.alert("没有卡信息!","patseat10");
		 	break;
		 case "-11":
		 	dhccBox.alert("卡没有启用!","patseat10");
		 	break;
		 case "-12":
		 	dhccBox.alert("卡未关联病人!","patseat10");
		 	break;
		 case "-13":
		 	dhccBox.alert("登记号长度有误！","patseat10");
		 	break;
		 case "-14":
		 	dhccBox.alert("登记号输入有误！","patseat10");
		 	break;	 	
	   }
		$('#RegNo').val("");   //病人登记号
		$('#CardNo').val("");   //病人卡号		
	}else{
		$('#RegNo').val(data.split("^")[0]);   //病人登记号
		$('#CardNo').val(data.split("^")[11]);   //病人卡号				
	}
}

function openCheckLev(){
	 var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
	 if(checkedRows.length==0){
		dhccBox.alert("请选择患者！","qxzhz");
		 return false;
		 }
	 		
	if(checkedRows[0].EpisodeID==""){
		dhccBox.alert("你选中的不是就诊患者！","qxzhz");
		return false;
		}
	if(checkedRows.length==1){
		var row=checkedRows[0]; 
        var EpisodeID=row.EpisodeID;
        var EmPCLvID=row.EmPCLvID;
		option={
			title :'分诊信息',
	  		type: 2,
	  		shadeClose: true,
	  		shade: 0.8,
	  		area: ['1150px','600px'],
	  		content:"dhcem.emerpatientinfo.csp?EpisodeID="+EpisodeID+"&EmPCLvID="+EmPCLvID
		}
		window.layer.open(option);	
		return false;
	}   
}

//格式化病人列表病人名字并给已就诊和未就诊赋值
function FormatterName(value, rowData, rowIndex) {
   	 if(rowData.PAPMINO.indexOf("未诊")>=0){
       	 $("#awaitDiagNum")[0].innerHTML ="（"+value+"）"; //待诊
       	 return "";
	}else if (rowData.PAPMINO.indexOf("已诊")>=0){
		 $("#haveDiagNum")[0].innerHTML ="（"+value+"）";  //已诊
	     return "";
	}else{						
		return value;	
	}
}

///卡号回车事件
function CardPress(){
	if ($('#CardNo').val() == "") {
        dhccBox.alert("卡号为空","EmptyCard");
        return
    }
    var CardNo = $('#CardNo').val();
    var m_lenght = $("#EmCardType").val().split("^")[17]
    for (i = CardNo.length; i < m_lenght; i++) {
        CardNo = "0" + CardNo;
    }
    
    ClearPatNum();  
   	 
   	PatInfoByCard(CardNo);
}

///该状态列表
function UpPatStatus(){
	/*
	var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
	 if(checkedRows.length==0){
		dhccBox.alert("请选择患者！","qxzhz");
		 return false;
	}
	 		
	if(checkedRows[0].EpisodeID==""){
		dhccBox.alert("你选中的不是就诊患者！","qxzhz");
		return false;
	}
	var row=checkedRows[0]; 
    var EpisodeID=row.EpisodeID;
    */
  	var PatStatus = $(this).find('a').attr('data-id')
    var title = $(this).find('a').text()+"(变更急诊病人状态)"
  	
	option={
		title :title,
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['500px','400px'],
  		content:"dhcem.statuschange.csp?EpisodeID="+"51"+"&PatStatus="+PatStatus
	}
	window.layer.open(option);
	return ;
	
}

///通过卡号取出病人信息并赋值卡号登记号
function PatInfoByCard(CardNo){
	 runClassMethod("web.DHCEMEmeraPatient", "GetPatInfoByCardOrRegNo",
        {'CardNo': CardNo, 'RegNo': ''},
        function (data) {
           SettingModel(data);
           //重新加载table
           if($('#RegNo').val()!=""){
           		search();    
           }
    }, "text", false);
}

///通过登记号取出病人信息并赋值卡号登记号
function PatInfoByReg(RegNo){
	 runClassMethod("web.DHCEMEmeraPatient","GetPatInfoByCardOrRegNo",
    {'CardNo':'','RegNo':RegNo},
    function(data){
	   SettingModel(data);
           //重新加载table
       if($('#RegNo').val()!=""){
       		search();    
       }
	},"text",false);
}

//清除左侧未完成已完成显示的数目
function ClearPatNum(){
   	$("#awaitDiagNum")[0].innerHTML ="（0）"; //待诊
	$("#haveDiagNum")[0].innerHTML ="（0）";  //已诊	
}

//隐藏左侧未完成已完成显示的数目
function ShowPatNum(){
	$("#awaitDiag").show();
	$("#haveDiag").show();
}

//隐藏左侧未完成已完成显示的数目
function HidePatNum(){
	$("#awaitDiag").hide();
	$("#haveDiag").hide();
}