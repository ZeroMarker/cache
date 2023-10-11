// dhcpepreiadm.review.js
// dhcpepreiadm.review.csp
// 预约复查记录时关联已检查的记录

$(function() {
	InitDataGrid();
	
	$("#RVColse").click(function(){
		RVColse();
	});
});

function InitDataGrid() {
	debugger;
	$HUI.datagrid("#HadSumRecord", {
		url: $URL,
		queryParams: {
			ClassName: "web.DHCPE.PreIADM",
			QueryName: "GetHadSummaryList",
			RegNo: $("#RVRegNo").val(),
			IDCard: $("#RVIDCard").val(),
			CardType: $("#RVCardType").val(),
			VIPLevel: $("#RVVIPLevel").val(),
			HospID: session["LOGON.HOSPID"],
			LocID: session["LOGON.CTLOCID"]
		},
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 50,
		pageList : [50,100,200],
		singleSelect: true,
		onDblClickRow:function(rowIndex, rowData) {
			var RVSelectID = rowData.PreIADM;
			$("#RVSelectID").val(RVSelectID);
			$HUI.window("#ReviewWin").close();
		},
		onLoadSuccess:function(data) {
			if (data.rows.length <= 0) {
				if ($("#RVSelectID").val() == "") {  // 防止重复
					$("#RVSelectID").val("NoSumRecord");
					$HUI.window("#ReviewWin").close();
				}
			}
		}
	});
}

function RVColse() {
	$("#RVSelectID").val("RVColse");
	$HUI.window("#ReviewWin").close();
}