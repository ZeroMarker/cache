$(function () {
	InitPescTimeLine();
})
function InitPescTimeLine(){
    var retData = $.cm(
        {
            ClassName: 'PHA.OP.DispQuery.Query',
            QueryName: 'PrescOperRecords',
            inputStr: PHA_PrescNo
        },
        false
    );
    var itemsArr = [];
    var rowsData = retData.rows;
    for (var i = 0; i < rowsData.length; i++) {
        var rowData = rowsData[i];
        var contextArr = [];
        contextArr.push('<div>');
        contextArr.push(rowData.dateTime);
        contextArr.push('</div>');
        contextArr.push('<div>');
        contextArr.push(rowData.userName);
        contextArr.push('</div>');
        var item = {};
        item.title = rowData.psName;
        item.context = contextArr.join('');
        itemsArr.push(item);
    }
	$('.vstep').children().remove();
	$("#presctimeline").vstep({
        //showNumber:false,
        stepHeight:70,
       	currentInd:rowsData.length,
        onSelect:function(ind,item){console.log(item);},
        //titlePostion:'top',
        items:itemsArr
    });
  
}

function ReLoadUXPrescTimeLine(adm_opts){
	InitPescTimeLine()
	
}