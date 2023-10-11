///add by ZY   2826780  20220926

var ManufactoryDR=getElementValue("ManufactoryDR");
var VendorDR=getElementValue("VendorDR");
$(function(){
    initDocument();
});
function initDocument(){
    initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    $HUI.datagrid("#tDHCEQProxyAuthorizationList",{
        url:$URL,
        queryParams:{
                ClassName:"web.DHCEQ.Plat.CTProduct",
                QueryName:"GetProxyAuthorizationList",
                ManufactoryDR:ManufactoryDR,
                VendorDR:VendorDR
        },
        rownumbers: true,  //如果为true，则显示一个行号列。
        singleSelect:true,
        fit:true,
        border:false,
        bodyCls:'table-splitline',	//modified by ZY20230209 bug:3163826
        //striped : true,
        //cache: false,
        //fitColumns:true,
        columns:[[
                /*{field:'ManufactoryDR',hidden:true,rowspan:2},
                {field:'Manufactory',title:'生产厂家',width:200,align:'left',rowspan:2},
                {field:'VendorDR',hidden:true,rowspan:2},
                {field:'Vendor',title:'供应商',width:200,align:'left',rowspan:2},
                */
                {field:'ProductDR',hidden:true,rowspan:2},
                {field:'Product',title:'产品',width:200,align:'left',rowspan:2},
                {field:'Level',hidden:true,rowspan:2},
                {title:'授权信息',colspan:6}],
                [{field:'PALevel',title:'授权级别',width:80,align:'left',rowspan:1},
                {field:'PARowID',hidden:true,rowspan:1},
                {field:'PAAuthorizer',title:'授权者',width:250,align:'left',rowspan:1},
                {field:'PAAuthorized',title:'被授权者',width:250,align:'left',rowspan:1},
                {field:'PADesc',title:'证书描述',width:100,align:'left',rowspan:1},
                {field:'PAAvailableDate',title:'有效期',width:200,align:'left',rowspan:1},
                {field:'PALimitFlag',title:'限定产品',width:80,align:'center',rowspan:1}
            ]],
        //ManufactoryDR,Manufactory,VendorDR,Vendor,ProductDR,Product,Level,PARowID,PALevel,PAManufactory,PAAuthorizer,PAAuthorized,
        //PADesc,PANo,PAAuthorizDate,PAAvailableDate,PAContext,PARemark,PALimitFlag,PAActiveFlag
        onClickRow:function(rowIndex,rowData){onClickRow(rowIndex,rowData);},
        pagination:true,
        pageSize:25,
        pageNumber:1,
        pageList:[25,50,75,100],
        onLoadSuccess:function(data){
            //合并行
            for (var i = 0; i < data.rows.length; i++){
                var num=data.rows[i].Level;  //5  null
                var merges = [      //所要合并的行字段
                    {field: 'ProductDR'},
                    {field: 'Product'},
                    {field: 'Level'}
                ];
                for (var k = 0; k < merges.length; k++) {        //循环读取合并行的字段，并进行合并
                    $("#tDHCEQProxyAuthorizationList").datagrid('mergeCells', {
                        index: i*1,
                        field: merges[k].field,
                        rowspan:num
                    });
                }
                i=i+num-1
            }
        }
    });
};

function onClickRow(rowIndex,rowData)
{
    if (rowData.ProductDR>0)
    {
        messageShow("confirm","info","提示","是否选择当前产品的授权信息?","",
            function(){
                /*
                var Date=getElementValue("Date");
                var User=getElementValue("User");
                var Job=getElementValue("Job");
                var nodestr=getElementValue("nodestr");
                var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SetChoiceProductDR",rowData.ProductDR,nodestr,Date,User,Job)
                if (jsonData!=0) {messageShow("","","",jsonData);return;}
                */
                websys_showModal("options").mth(rowData.ProductDR);
            },
            function(){
                return
            },
            "确定",
            "取消"
        );
    }
}
