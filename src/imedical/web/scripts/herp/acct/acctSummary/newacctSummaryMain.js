
var userid = session['LOGON.USERID'];
//var acctbookid=GetAcctBookID();
var acctSummaryMain = new dhc.herp.Grid({
        title: '凭证摘要维护',
        width: 400,
		iconCls:'maintain',
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctsummaryexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
            id:'summcode',
            header: '摘要序号',
			allowBlank: false,
			width:150,
			update:true,
            dataIndex: 'summcode'
        },{
            id:'summary',
            header: '摘要',
			allowBlank: false,
			width:300,
			update:true,
            dataIndex: 'summary'
        },{								//rowid CompDR  Year AdjustNo AdjustAate AdjustFile Memo IsApprove IsElast ElastMonth
            id:'spell',
            header: '拼音码',
            //allowBlank: false,
			width:220,
			update:true,
			editable:false,
            dataIndex: 'spell'
        }] 
});
	//var peg = new PrintExtgrid(this);
    //itemGrid.hiddenButton(3);
	//acctSummaryMain.hiddenButton(4);
	acctSummaryMain.btnResetHide();
	acctSummaryMain.btnPrintHide();
//	var	acctbookid=IsExistAcctBook(); //判断当前账套是否存在