/// Creator: yuliping
/// CreateDate: 2017-01-11
$(document).ready(function() {
     
	initform(); //初始化表单录入框
	initLocTable();//初始化科室人员列表
	initItemTable();//初始化可配送明细列表
//人员查询
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
//点击select的差号，重新加载
$("#clearRecUser").click(function(){
	var loc=$('#RecLoc').val();
	$('#locUsers').dhccQuery({query:{LULocDr:loc,LUUserDr:''}});
	});
//点击select的差号，重新加载
$("#ClearLocItem").click(function(){
	var loc=$("#valueOfLoc").val();
	$('#LOCItemTable').dhccQuery({query:{LocUser:loc,itemName:''}});
	});
})

//初始化表单录入框
function initform(){
	$('#RecLoc').dhccSelect({  //接收科室
		url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp
	});
	$('#RecUser').dhccSelect({  //人员
		url:LINK_CSP+"?ClassName=web.DHCDISLocUser&MethodName=GetSSUser&HospID="+hosp
	});
	$('#LocItem').dhccSelect({  //项目名称
		url:LINK_CSP+"?ClassName=web.DHCDISLocItem&MethodName=ListItem"
	});
$("#clearRecUser").find("tr").click(function(){
	$(this).addClass("select")
	})
}
function initLocTable(){
	
	var columns=[
		 
		{field:'LULocDr',title:'科室',width:240,align:'center'},
		{field:'LUUserInit',title:'人员工号',width:25,align:'center'},
		{field:'UserDesc',title:'人员姓名',width:25,align:'center'},
	    {field:'LUActiveFlag',title:'启用',width:20}
	   
	];
    $('#locUsers').dhccTable({
	     formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "第 "+pageFrom+" 到第 "+pageTo+" 条记录，共 "+totalRows+" 条记录"
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
		{field:'ItemDesc',title:'项目名称',width:50,align:'center'},
	    {field:'ItemLoc',title:'去向',width:20}
	   
	];
	
	 $('#LOCItemTable').dhccTable({
	     formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "第 "+pageFrom+" 到第 "+pageTo+" 条记录，共 "+totalRows+" 条记录"
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

//按科室查询
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
