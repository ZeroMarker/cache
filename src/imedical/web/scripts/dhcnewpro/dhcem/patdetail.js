$(document).ready(function() {
	

    $('#patTable').bootstrapTable({
	    height:$(window).height()-125,
	    formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
	    pagination:'true',
	    sidePagination:'server',
	    pagination:true,
	    showHeader:false,
		iconsPrefix:'fa',
		clickToSelect:true,
		pageSize:7,
		sidePagination: "server", //����˴����ҳ
		dataType: "json",
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPat&MethodName=QueryPat',
        columns: [
        {
            field: 'ff',
            formatter:'patFormatter'
        }],
        onLoadSuccess:function(data){
	        total=data.total
			$("#patPanel .btn-group-justified .btn-mint").html(data.levelFour+"/"+total)
			$("#patPanel  .btn-group-justified .btn-warning").html(data.levelThree+"/"+total)
			$("#patPanel  .btn-group-justified .btn-danger").html(data.levelOne+"/"+total)
			$("#patPanelHeading .panel-title").html("���Ʋ���("+total+")")
	    },
	    onClickRow:function(row, $element, field){
		    alert(row.CardNo)
		}
    });
	
	
	
    // EDITABLE - COMBINATION WITH X-EDITABLE
    // =================================================================
    // Require X-editable
    // http://vitalets.github.io/x-editable/
    //
    // Require Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    //
    // Require X-editable Extension of Bootstrap Table
    // http://bootstrap-table.wenzhixin.net.cn/
    // =================================================================
    $('#demo-editable').bootstrapTable({
	    height:$(window).height()-225,
	    pageSize:6,
		showRefresh:true,
		showToggle:true,
		iconsPrefix:'fa',
		clickToSelect:true,
        idField: 'id',
        url: 'data/bs-table.json',
		toolbar: '#toolbar',                //���߰�ť���ĸ�����
        columns: [{
            checkbox: true
        },{
            field: 'ff',
            title: '��ӡ���'
        }, {
            field: 'name',
            title: 'Name'
        }, {
            field: 'date',
            title: '�ǼǺ�'
        }, {
            field: 'amount',
            title: '��λ��',
            editable: {
                type: 'text'
            }
        }, {
            field: 'status',
            align: 'center',
            title: '��������'
        }, {
            field: 'track',
            title: '�������',
			align: 'center'
        }]
    });
});	


function patFormatter(value, rowData) {
	
    	var htmlstr =  '<div class="celllabel"><h3 style="float:left">'+ rowData.PatName +'</h3><h3 style="float:right"><span>'+ rowData.Sex +'/'+ rowData.Age +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left">ID:'+ rowData.CardNo +'</h4>';
		classstyle="color: #18bc9c";
		if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
		if(rowData.NurseLevel==2) {classstyle="color: #f22613"};
		level=""
		if(rowData.NurseLevel>0){
			level=rowData.NurseLevel+"��";
		}
		htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></h4></div>';
	
		return htmlstr;
}