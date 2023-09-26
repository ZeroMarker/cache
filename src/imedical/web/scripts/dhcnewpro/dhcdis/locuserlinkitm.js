/// Creator: yuliping
/// CreateDate: 2017-01-11
$(document).ready(function() {
     
	initform(); //��ʼ����¼���
	initLocTable();//��ʼ��������Ա�б�
	initItemTable();//��ʼ����������ϸ�б�
//��Ա��ѯ
$("#RecUser").change(function(){
	var user=$("#RecUser").val();
	
	var loc=$('#RecLoc').val();
  	setTimeout(function(){
	 	 $('#locUsers').dhccQuery({query:{LULocDr:loc,LUUserDr:user}});
  	},100);
});

$("#LocItem").change(function(){
	var item=$("#LocItem").val();
	var locuser=$("#valueOfLoc").val();
	
  	setTimeout(function(){
	 	 $('#LOCItemTable').dhccQuery({query:{LocUser:locuser,itemName:item}});
  	},100);
});
//���select�Ĳ�ţ����¼���
$("#clearRecUser").click(function(){
	var loc=$('#RecLoc').val();
	$('#locUsers').dhccQuery({query:{LULocDr:loc,LUUserDr:''}});
	});
//���select�Ĳ�ţ����¼���
$("#ClearLocItem").click(function(){
	var loc=$("#valueOfLoc").val();
	$('#LOCItemTable').dhccQuery({query:{LocUser:loc,itemName:''}});
	});
})

//��ʼ����¼���
function initform(){
	$('#RecLoc').dhccSelect({  //���տ���
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	$('#RecUser').dhccSelect({  //��Ա
		url:LINK_CSP+"?ClassName=web.DHCDISLocUser&MethodName=GetSSUser&HospID="+hosp
	});
	$('#LocItem').dhccSelect({  //��Ŀ����
		url:LINK_CSP+"?ClassName=web.DHCDISLocItem&MethodName=ListItem"
	});
$("#clearRecUser").find("tr").click(function(){
	$(this).addClass("select")
	})
}
function initLocTable(){
	
	var columns=[
		 
		{field:'LULocDr',title:'����',width:240,align:'center'},
		{field:'LUUserInit',title:'��Ա����',width:25,align:'center'},
		{field:'UserDesc',title:'��Ա����',width:25,align:'center'},
	    {field:'LUActiveFlag',title:'����',width:20}
	   
	];
    $('#locUsers').dhccTable({
	     formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "�� "+pageFrom+" ���� "+pageTo+" ����¼���� "+totalRows+" ����¼"
		},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    height:$(window).height()-180,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=ListLocUser',
        singleSelect:true,
        columns: columns,
        showToggle:false,
        queryParam:{
	   
	        LULocDr:'',
	        LUUserDr:''
	        
	        },
		onDblClickRow:function(row){
			},
		onClickRow:function(row,$element){
			 //$(".select").removeClass("select");
			 //$element.find("td").addClass("select");
			 $(".selectTable").removeClass("selectTable");
			 $element.addClass("selectTable");
			 $("#valueOfLoc").val(row.ID)
			 $('#LOCItemTable').dhccQuery({query:{LocUser:row.ID,itemName:''}});
			}
    })
}

function initItemTable(){
	
	var mycolumns=[
		{field:'ItemDesc',title:'��Ŀ����',width:50,align:'center'},
	    {field:'ItemLoc',title:'ȥ��',width:20}
	   
	];
	
	 $('#LOCItemTable').dhccTable({
	     formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "�� "+pageFrom+" ���� "+pageTo+" ����¼���� "+totalRows+" ����¼"
		},
	    formatRecordsPerPage:function(pageNumber){return ''},
	    height:$(window).height()-180,
	    pageSize:10,
	    pageList:[50,80],
	    striped:true,
        url: 'dhcapp.broker.csp?ClassName=web.DHCDISLocItem&MethodName=getItemByUser',
        singleSelect:true,
        clickToSelect:true,
        columns: mycolumns,
        queryParam:{
	  		LocUser:'',
	  		itemName:''
	        },
		onDblClickRow:function(row){
			},
		onClickRow:function(row,$element){
			
			$(".selectLocTable").removeClass("selectLocTable");
			 $element.addClass("selectLocTable");
			//console.log(this)
			}
    })
	
	}

//�����Ҳ�ѯ
function searchByLoc(){
	var loc=$('#RecLoc').val();
	
	$('#locUsers').dhccQuery({query:{LULocDr:loc,LUUserDr:''}});
	}
function delItem(){
	
	if (select){
		value=select.id;
		OrderType=mPiece(value,String.fromCharCode(4),0);
		itemid=value.split(String.fromCharCode(4))[2];
	}
	
	}
$(function () {
    $("#LOCItemTable > tbody > tr").click(function () {
        location.href = $(this).find("a").attr("href");
        alert(1)
    });
})
