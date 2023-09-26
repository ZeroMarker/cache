/// Creator: huaxiaoying
/// CreateDate: 2017-01-05
$(document).ready(function() {
     
	initform(); //��ʼ����¼���
	inittable(); //��ʼ��table
	refreshTableHeader()
    $("#left").css("height",$(window).height()-107);
	
	$('#regNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            regNoBlur()
        }
    });
	//$("#save").click(function(){
	//	$("#save").css("background","#c7ddf2");	
	//});

	
})
///���㷽��
function regNoBlur()
{
	var i;
    var regNo=$('#regNo').val();
    var oldLen=regNo.length;
    if (oldLen==10) return;
	if (regNo!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    //for (i=0;i<8-oldLen;i++)
	    {
	    	regNo="0"+regNo 
	    }
	}
    $("#regNo").val(regNo);
}
///����
function save(){
	regNo=$('#regNo').val();
	bedNo=$('#bedNo').val();
	ward=$('#ward').val();
	jobId=$('#jobId').val();
	RecLoc=$('#RecLoc').val();
	StartDate=$('#StartDate input').val(),
	startTime=$('#startTime input').val(),
	ReqType=$('#ReqType').val(),
	ReqWay=$('#ReqWay').val(),
	ReqNum=$('#ReqNum').val(),
	note=$('#note').val();
	if(regNo==""){
		dhccBox.alert("����д�ǼǺţ�","request-one");
	}else if(bedNo==""){
		dhccBox.alert("����д���ţ�","request-two");
	}else if(ward==""){
		dhccBox.alert("����д���ڲ�����","request-three");
	}else if(jobId==""){
		dhccBox.alert("����д����ID��","request-four");
	}else if(RecLoc==null){
		dhccBox.alert("����д���տ��ң�","request-five");
	}else if(StartDate==""){
		dhccBox.alert("��ѡ������ʱ������ڣ�","request-six");
	}else if(startTime==""){
		dhccBox.alert("��ѡ�����д����ʱ�䣡","request-seven");
	}else if(ReqType==null){
		dhccBox.alert("��ѡ���������ͣ�","request-eight");
	}else if(ReqWay==null){
		dhccBox.alert("��ѡ�����ͷ�ʽ��","request-nine");
	}else if(ReqNum==null){
		dhccBox.alert("��ѡ������������","request-ten");
	}
	alert(regNo+bedNo+ward+jobId+RecLoc+StartDate+startTime+ReqType+ReqWay+ReqNum+note)
	
}
///  Ч��ʱ����¼�����ݺϷ��� 
function CheckDHCCTime(id){
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		dhccBox.alert("��¼����ȷ��ʱ���ʽ������:18:23,��¼��1823","register-three");
		return $('#'+ id).val();
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		dhccBox.alert("Сʱ�����ܴ���23��","register-one");
		return $('#'+ id).val();
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		dhccBox.alert("���������ܴ���59��","register-two");
		return $('#'+ id).val();
	}	
	return hour +":"+ itme;
}
/// ��ȡ�����ʱ�������� add
function SetDHCCTime(id){
		
	var InTime = $('#'+ id).val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
///�������
function lefthide(){
	leftshowHeight=$(window).height()-118
	$("#leftshow").show();
	$("#leftshow").css("height",leftshowHeight);
	//$("#goright").show();
	$("#left").hide();
	$("#goleft").hide();
	$("#right").css("left","31px");
}
///��ʾ���
function leftshow(){
	$("#left").show();
	$("#goleft").show();
	$("#goright").hide();
	$("#leftshow").hide();
	$("#right").css("left","228px");
}
///���header������
function refreshTableHeader(){
    var rtime = new Date();
    var timeout = false;
    var delta = 66;
    $(window).resize(function(){
        rtime = new Date();
        if(timeout == false){
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });
    function resizeend(){
        if(new Date() - rtime < delta){
            setTimeout(resizeend, delta);
        }else{
            timeout = false;
            $('#DisReqOrdTb').dhccTableM("resetWidth");
            //$('#DisReqOthTb').dhccTableM("resetWidth");
        }
    }
    
}
//��ʼ����¼���
function initform(){
	$('#RecLoc').dhccSelect({  //���տ���
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	$('#ReqType').dhccSelect({ //��������
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList"
	});
	$('#ReqWay').dhccSelect({ //���ͷ�ʽ
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList"
	});
	$('#ReqNum').dhccSelect({ //��������
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",
		minimumResultsForSearch:-1 
	});
	$('#StartDate').dhccDate();
	$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	
}
//��ʼ��table
function inittable(){
	//�����б�
	$('#DisReqPatTable').dhccTable({
		formatLoadingMessage:function() {return "";},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:6,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
        columns: [
        {
            field: 'ff',
            formatter:'testFormater'
        }],
        
        onLoadSuccess:function(data){
	        total=data.total
			$("#patTestTitle").html("Ƥ��("+total+")")
			if($("#EpisodeID").val()==""){
				if(total>0){
					$("#content-main").height(tabHeight);
					$("#EpisodeID").val(data.rows[0].EpisodeID);
					selectTest(data.rows[0].EpisodeID)   ;
				}
			}
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    
    //�������б�
	$('#patReqedTable').dhccTable({
		formatLoadingMessage:function() {return "";},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    showHeader:false,
		pageSize:6,
		url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
        columns: [
        {
            field: 'ff',
            formatter:'testFormater'
        }],
        
        onLoadSuccess:function(data){
	        total=data.total
			$("#patTestTitle").html("Ƥ��("+total+")")
			if($("#EpisodeID").val()==""){
				if(total>0){
					$("#content-main").height(tabHeight);
					$("#EpisodeID").val(data.rows[0].EpisodeID);
					selectTest(data.rows[0].EpisodeID)   ;
				}
			}
	    },
	    onClickRow:function(row, $element, field){
		    $("#EpisodeID").val(row.EpisodeID)
		    selectTest(row.EpisodeID)
		}
    });
    //��ѡ��Ŀ
	$('#DisReqSelectedProjectTb').dhccTable({
	    height:$(window).height()-262,
	    //sidePagination:'side',
	    pageSize:1000,
	    pageList:[1000,2000],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: 'ѡ��',checkbox: true},
        {
            field: 'num',
            title: '��ѡ��Ŀ'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: 'ȥ��'
        }
        ],
        queryParam:{
			regNo:$('#Regno').val(),    
    		fromDate:$('#StartDate input').val(),
    		MarkNo:$('#Loc').val()
		},
		onDblClickRow:function(row){
			window.location.href="dhcem.patchecklev.csp?regNo="+row.currregno+"&ChekLevId="+row.EpisodeIDYY+"&StartTimeQ="+$('#StartDate input').val()+"&EndTimeQ="+$('#EndDate input').val();	
			}
    })
    
    //ҽ��
    $('#DisReqOrdTb').dhccTable({
	    height:$(window).height()-317,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: 'ѡ��',checkbox: true},
        {
            field: 'num',
            title: 'δѡ��Ŀ'
        },{
            field: 'VeerLocDesc',
            align: 'center',
            title: '���ʱ��'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: '������'
        }
        ],
        queryParam:{
    		fromDate:$('#StartDate input').val()
		},
		onDblClickRow:function(row){
			}
    })
    //����
    $('#DisReqOthTb').dhccTable({
	    height:$(window).height()-317,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMRegister&MethodName=ListRegisterNewBySetting',
        singleSelect:true,
        columns: [
        //{title: 'ѡ��',checkbox: true},
        {
            field: 'num',
            title: 'δѡ��Ŀ'
        },{
            field: 'VeerLocDesc',
            align: 'center',
            title: '���ʱ��'
        }, {
            field: 'NurseLevel',
            align: 'center',
            title: '������'
        }
        ],
        queryParam:{
    		fromDate:$('#StartDate input').val()
		},
		onDblClickRow:function(row){
			}
    })
     
}