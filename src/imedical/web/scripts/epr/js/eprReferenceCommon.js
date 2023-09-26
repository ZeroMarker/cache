function getEpisodeStore() {
    var simpleStore = new Ext.data.JsonStore({
        url: '../web.eprajax.episodeListGrid.cls?patientID=' + patientID + '&admType=' + admitType + '&argDiagnosDesc=' + escape(chkDiagnos),
        fields: [
            { name: 'AdmDate' },
            { name: 'AdmTime' },
            { name: 'AdmType' },
            { name: 'Diagnosis' },
            { name: 'CurDept' },
            { name: 'EpisodeID' }
        ],
       	root: 'data',
		//获取总页数
		totalProperty: 'TotalCount'
    });

    simpleStore.on('loadexception', function(proxy, options, response, e) {
        alert(response.responseText);
    });

    return simpleStore;
}

var comboStore = new Ext.data.SimpleStore({
    fields: ['returnValue', 'displayText'],
    data: [['I', '住院'], ['O', '门诊'], ['E', '急诊']]
});

//就诊类型的转换（I：住院，O：门诊，E：急诊）
function getAdmitType(val) {
    if (val == "I") {
        return '<span style="color:green;">住院</span>';
    } else if (val == "O") {
        return '<span style="color:red;">门诊</span>';
    } else if (val == "E") {
        return '<span style="color:blue;">急诊</span>';
    }
    return val;
}

function getRefLogStore() {
    var store = new Ext.data.JsonStore({
        url: '../web.eprajax.reference.refjournal.cls?Action=Reference&EpisodeID=' + episodeID + '&RefType=' + refType + "&UserID" + userID,
        fields: [
            { name: 'Title' },
            { name: 'Status' },
            { name: 'RefDate' },
            { name: 'RefTime' },
            { name: 'RefUser' }
        ]
    });
    return store;
}