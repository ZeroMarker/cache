/// Creator: nisijia
/// CreateDate: 2016-11-16

var RegQue="",ArrivedQue="",AllPatient=""   //���ڲ�ѯ���ۣ������۵�

$(document).ready(function () {

    //��ʼ��ʱ��
    initDate();

    //���¼�
    initMethod();

    //��ʼ��cobobox
    initCardCombo();

    //��ʼ�����
    initTable();

    //���ý���λ��
    $('#cardNo').focus();
    
    $('.selectpicker').selectpicker({  
         'selectedText': 'cat'  
     }); 
     
    myheight=$(window).height()-70,
    $('.emerPatient .left').css("height",myheight);  //hxy �����������Ӧ
   
});


function initCardCombo() {
    $('#Loc').selectpicker({
			noneSelectedText:"==��ѡ��=="
        })
    runClassMethod("web.DHCEMPatCheckLevCom", "CardTypeDefineListBroker", {},
        function (data) {
            var carArr = []; //�����ҵ�
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
    $('#CardNo').val("");  /// �������
}

//����
function readCardNo() {
    var myEquipDR = $('#EmCardType').val();
    //�����ͣ�"0^1^default.."
    var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			//����Ч
			var CardNo = myary[1];
			$('#CardNo').val(CardNo);
			CardPress();
			break;
		case "-200":
			//����Ч
			dhccBox.alert("��ʾ","����Ч!");
			break;
		case "-201":
			//�ֽ�
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNo').val(CardNo);     /// ����
			$('#RegNo').val(PatientNo);   /// �ǼǺ�
			break;
		default:
	}
}

///  Ч��ʱ����¼�����ݺϷ��� 
function CheckDHCCTime(id) {
    var InTime = $('#' + id).val();
    if (InTime == "") {
        return "";
    }

    if (InTime.length < 4) {
        InTime = "0" + InTime;
    }
    if (InTime.length != 4) {
        dhccBox.alert("��¼����ȷ��ʱ���ʽ������:18:23,��¼��1823", "register-three");
        return $('#' + id).val();
    }

    var hour = InTime.substring(0, 2);
    if (hour > 23) {
        //dhccBox.alert("�ҵ�message","classname");
		dhccBox.alert("Сʱ�����ܴ���23��", "register-one");
        return $('#' + id).val();
    }

    var itme = InTime.substring(2, 4);
    if (itme > 59) {
        dhccBox.alert("���������ܴ���59��", "register-one");
        return $('#' + id).val();
    }
    return hour + ":" + itme;
}

/// ��ȡ�����ʱ�������� add 2016-09-23
function SetDHCCTime(id) {

    var InTime = $('#' + id).val();
    if (InTime == "") {
        return "";
    }
    InTime = InTime.replace(":", "");
    return InTime;
}
///���Ұ�ť
function search() {
	//dhccBox.alert(RegQue+":"+ArrivedQue+":"+AllPatient);
	//���ű�ƴ��
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

	//�������ۣ������ۣ���������
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
            LocHao:ArcDataList,   //��ѡ�кű�����̨
            HospID:hosp,
            GropID:LgGroupID  
        }
    })
}
//���˿�Ƭ
function setPanel(data) {

}

///��ʼ��ʱ��ؼ�
function initDate() {
    //������ʼ����
    $('#EndDate').dhccDate();
    //$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))

    $('#StartDate').dhccDate();
    //$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))
    runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 ���ڸ�ʽ������
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
	//�ٴη���
    $("#upCheckLev").on('click', function () {
        var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
        if(checkedRows.length==0){
		 dhccBox.alert("��ѡ���ߣ�","SelPat");
		 return false;
		 }
		var row = checkedRows[0];
		window.open ("dhcem.empatchecklev.csp?EpisodeID="+row.EpisodeID, "newwindow", "height=450, width=400, toolbar =no,top=100,left=500,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") 	
		return false;
    })
	
    //����
    $("#readCardNo").on('click', function () {
        readCardNo();
    })

    //���Ұ�ť������ť ���水ť
    $("#Find").on('click', function () {
        search();
    })
    //�����б�
    $("#patientList").on('click',function(){
	    ShowPatNum();
		$("#btnpatient span")[0].innerHTML="�����б�";
		RegQue="";
		ArrivedQue="";
		AllPatient="";
		search();
    })
    //����
    $("#attention").on('click',function(){
	    HidePatNum();
		$("#btnpatient span")[0].innerHTML="����";
		RegQue="";
		ArrivedQue="";
		AllPatient="on";
		search();
		
    })
    //��������
    $("#bttention").on('click',function(){
	    HidePatNum();
		$("#btnpatient span")[0].innerHTML="��������";
		RegQue="";
		ArrivedQue="on";
		AllPatient="";
		search(); 
		
    })
    //������
    $("#nattention").on('click',function(){
		HidePatNum();
		$("#btnpatient span")[0].innerHTML="������";
		RegQue="on";
		ArrivedQue="";
		AllPatient="";
		search(); 
    })
	//����
    $("#awaitDiag").on('click', function () {
        search("N");
    });
	//����
    $("#haveDiag").on('click', function () {
        search("Y"); 
    });
    //���ڴ���
    $("#nowDiag").on('click',function(){
	 	//search("Y"); 
    });
    //����
    $("#admissions").on('click',function(){
		var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
    	if(checkedRows.length==0){
		      dhccBox.alert("��ѡ��һ����¼","patRentList-three");
	              return;
	        }else{ 
	        var row=checkedRows[0]; 
        	var EpisodeID=row.EpisodeID
        	var patientId=row.PatientID      
	        window.location.href="dhcem.docmainoutpat.csp?EpisodeID="+EpisodeID
	        }
    });
    //����
    $("#triage").on('click',openCheckLev);
    //�˺�
    $("#backNumber").on('click',function(){	
    	var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
    	var row=checkedRows[0]; 
		var patname=row.PAPMIName;
        var EpisodeID=row.EpisodeID;
    	var backNumber=confirm("��ȷ��Ҫ"+patname+"�˺���!");
	 	if(backNumber==true){
	 		runClassMethod("web.DHCDocOutPatientList","SetAllowReturn",{"EpisodeID":EpisodeID,"DoctorId":LgUserCode},function(jsonObj){
				if(jsonObj==0){
					dhccBox.alert("�ɹ�","Succ")
				}   	
     		});
   		 }else{
	 			return;   
   			 }
    });
	
    //�ǼǺŻس�
    	$('#RegNo').on('keypress', function(e){   
        // �����س�����  
       e=e||event;
       if(e.keyCode=="13"){
	     if($('#RegNo').val()==""){
		 	dhccBox.alert("�ǼǺ�Ϊ��","EmptyReg");    
		 	return
		 }
		var regNo = $('#RegNo').val(); 
		var m_lenght = ""
		
		///��ȡ��̨���õǼǺų���
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
	   
    //���Żس�
    $('#CardNo').on('keypress', function (e) {
        e = e || event;
        if (e.keyCode == "13") {
	        CardPress();    
        }
    });
    
    //�޸�״̬�ı�
    $('#upCheckLev .dropdown-menu li').on('click',UpPatStatus)

}

//��������� NSJ 2017-02-09
function awaitDiagNum(data) {
	
    var awaitDiagNum = 0;
    var haveDiagNum = 0;
    var nowDiagNum=0
    for (i = 0; i < data.length; i++) {
        if(data[i].WalkStatus=="����") {
            haveDiagNum++;   //����
        } else if(data[i].WalkStatus==""){
             //����
            awaitDiagNum++
        }/* else{
	        haveDiagNum++
        } */
		
    }
     $("#nowDiagNum")[0].innerHTML ="��"+nowDiagNum+"��";  //���ڴ���
     $("#awaitDiagNum")[0].innerHTML ="��"+awaitDiagNum+"��"; //����
     $("#haveDiagNum")[0].innerHTML ="��"+haveDiagNum+"��";  //����
}

function initTable() {
    var columns = [
    		{
    			checkbox: true,
    			title:'ѡ��'
 			},
 			
    		{
                field: 'Num',
                title: '���'
            },
            //{
            //    field: 'EpisodeID',
            //    title: '����ID'
            //},
            //{
            //    field: 'PatientID',
            //    title: '����ID'
            //},
            {
                field: 'PAPMINO',
                title: '�ǼǺ�'
            },
             {
                field: 'PAAdmPriority',
                align: 'center',
                title: '��ʿ�ּ�',
                formatter:updateFontColor
            },
            {
                field: 'PAPMIName',
                title: '����',formatter:FormatterName
            }, {
                field: 'PAPMISex',
                title: '�Ա�'
            }, {
                field: 'PAPMIDOB',
                title: '��������'
            }, {
                field: 'PAPMIAge',
                title: '����'
            }, {
                field: 'PAAdmDocCodeDR',
                align: 'center',
                title: 'ҽ��'
            }, {
                field: 'WalkStatus',
                align: 'center',
                title: '״̬'
            }, {
                field: 'PAAdmDate',
                align: 'center',
                title: '��������'
            }, {
                field: 'PAAdmTime',
                align: 'center',
                title: '����ʱ��'
            }, {
                field: 'PAAdmDepCodeDR',
                align: 'center',
                title: '�������'
            }, {
                field: 'PAAdmReason',
                align: 'center',
                title: '��������'
            },{
                field: 'Diagnosis', 
                align: 'center',
                title: '���'
               
            },{
                field: 'RegDoctor',
                align: 'center',
                title: '�ű�'
            },
             {
                field: 'PAAdmWard',
                align: 'center',
                title: '����'
            },
             {
                field: 'PAAdmBed',
                align: 'center',
                title: '��λ��'
            },{
                field: 'LocSeqNo',
                align: 'center',
                title: '˳���'
            }
        ]
    //���
    $('#ccPatientTb').dhccTable({
        height: $(window).height()-163,//hxy 2017-02-21 ȥ������
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
	    if(value.indexOf("1��")!="-1"){
		    return '<span style="color:red">'+value+'</span>';
		}
		if(value.indexOf("2��")!="-1"){
			return '<span style="color:red">'+value+'</span>';	
		}
		if(value.indexOf("3��")!="-1"){
			return '<span style="color:#f9bf3b">'+value+'</span>';	
		}
		if(value.indexOf("4��")!="-1"){
			return '<span style="color:green">'+value+'</span>';	
		}
	}
}

//����Modelģ������    
function SettingModel(data){
	if(data.split("^").length=="1"){
	   switch(data){
		 case "-10":
		 	dhccBox.alert("û�п���Ϣ!","patseat10");
		 	break;
		 case "-11":
		 	dhccBox.alert("��û������!","patseat10");
		 	break;
		 case "-12":
		 	dhccBox.alert("��δ��������!","patseat10");
		 	break;
		 case "-13":
		 	dhccBox.alert("�ǼǺų�������","patseat10");
		 	break;
		 case "-14":
		 	dhccBox.alert("�ǼǺ���������","patseat10");
		 	break;	 	
	   }
		$('#RegNo').val("");   //���˵ǼǺ�
		$('#CardNo').val("");   //���˿���		
	}else{
		$('#RegNo').val(data.split("^")[0]);   //���˵ǼǺ�
		$('#CardNo').val(data.split("^")[11]);   //���˿���				
	}
}

function openCheckLev(){
	 var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
	 if(checkedRows.length==0){
		dhccBox.alert("��ѡ���ߣ�","qxzhz");
		 return false;
		 }
	 		
	if(checkedRows[0].EpisodeID==""){
		dhccBox.alert("��ѡ�еĲ��Ǿ��ﻼ�ߣ�","qxzhz");
		return false;
		}
	if(checkedRows.length==1){
		var row=checkedRows[0]; 
        var EpisodeID=row.EpisodeID;
        var EmPCLvID=row.EmPCLvID;
		option={
			title :'������Ϣ',
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

//��ʽ�������б������ֲ����Ѿ����δ���︳ֵ
function FormatterName(value, rowData, rowIndex) {
   	 if(rowData.PAPMINO.indexOf("δ��")>=0){
       	 $("#awaitDiagNum")[0].innerHTML ="��"+value+"��"; //����
       	 return "";
	}else if (rowData.PAPMINO.indexOf("����")>=0){
		 $("#haveDiagNum")[0].innerHTML ="��"+value+"��";  //����
	     return "";
	}else{						
		return value;	
	}
}

///���Żس��¼�
function CardPress(){
	if ($('#CardNo').val() == "") {
        dhccBox.alert("����Ϊ��","EmptyCard");
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

///��״̬�б�
function UpPatStatus(){
	/*
	var checkedRows=$('#ccPatientTb').dhccTableM('getSelections');
	 if(checkedRows.length==0){
		dhccBox.alert("��ѡ���ߣ�","qxzhz");
		 return false;
	}
	 		
	if(checkedRows[0].EpisodeID==""){
		dhccBox.alert("��ѡ�еĲ��Ǿ��ﻼ�ߣ�","qxzhz");
		return false;
	}
	var row=checkedRows[0]; 
    var EpisodeID=row.EpisodeID;
    */
  	var PatStatus = $(this).find('a').attr('data-id')
    var title = $(this).find('a').text()+"(������ﲡ��״̬)"
  	
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

///ͨ������ȡ��������Ϣ����ֵ���ŵǼǺ�
function PatInfoByCard(CardNo){
	 runClassMethod("web.DHCEMEmeraPatient", "GetPatInfoByCardOrRegNo",
        {'CardNo': CardNo, 'RegNo': ''},
        function (data) {
           SettingModel(data);
           //���¼���table
           if($('#RegNo').val()!=""){
           		search();    
           }
    }, "text", false);
}

///ͨ���ǼǺ�ȡ��������Ϣ����ֵ���ŵǼǺ�
function PatInfoByReg(RegNo){
	 runClassMethod("web.DHCEMEmeraPatient","GetPatInfoByCardOrRegNo",
    {'CardNo':'','RegNo':RegNo},
    function(data){
	   SettingModel(data);
           //���¼���table
       if($('#RegNo').val()!=""){
       		search();    
       }
	},"text",false);
}

//������δ����������ʾ����Ŀ
function ClearPatNum(){
   	$("#awaitDiagNum")[0].innerHTML ="��0��"; //����
	$("#haveDiagNum")[0].innerHTML ="��0��";  //����	
}

//�������δ����������ʾ����Ŀ
function ShowPatNum(){
	$("#awaitDiag").show();
	$("#haveDiag").show();
}

//�������δ����������ʾ����Ŀ
function HidePatNum(){
	$("#awaitDiag").hide();
	$("#haveDiag").hide();
}