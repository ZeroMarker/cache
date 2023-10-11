function getfilepath(filename) {
	var data=""
	if(plus.os.name == "Android") {
		data = plus.io.convertLocalFileSystemURL("_downloads/");
		data += filename;
	} else {
		data = '_downloads/'+ filename
	}
	return data;
}

function getAllEntrys(callBack) {
	plus.io.resolveLocalFileSystemURL("_downloads/", function(entry) {
		var dirReader = entry.createReader();
		dirReader.readEntries(function(entries) {
			entries.sort(sortCompareEntry);
			callBack(entries)
		}, function(e) {
			callBack();
		});
	}, function(e) {
		callBack();
	});
}

function isHavefile(filename, callBack) {
	getAllEntrys(function(entries) {
		if (!entries) {
			callBack("none");
			return
		}
		var currentEntry = 0;
		for (var i = 0; i < entries.length; i++) {
			var oneEntry = entries[i];
			if (oneEntry.name == filename) {
				currentEntry = 1;
				break;
			}
		}
		if (currentEntry == 0) { //本地没有文件时
			callBack("none");
		} else {
			var data = getfilepath(filename);
			callBack(data);
		}
	});
}

function deleteOldApks(filename) {
	getAllEntrys(function(entries) {
		if (!entries) {
			return
		}
		var descEntry;
		for (var i = 0; i < entries.length; i++) {
			var oneEntry = entries[i];
			if (oneEntry.name == filename) {
				descEntry = oneEntry;
				break
			}
		}
		if (!descEntry) {
			return
		}
		descEntry.remove(function(successBlock) {}, function(error) {});
	})
}
function deleteAllFiles(callBack) {
	getAllEntrys(function(entries) {
		if (!entries) {
			callBack(0);
			return
		}
		var count = entries.length
		if (count == 0) {
			callBack(0);
			return
		}
		for (var i = entries.length - 1; i >= 0; i--) {
			entries[i].remove(function(){
				callBack(count);
			},function(error){
				callBack(count);
			});
		}
	})
}

function sortCompareEntry(a, b) {
	if (a.isDirectory && b.isFile) {
		return -1;
	} else if (a.isFile && b.isDirectory) {
		return 1;
	} else {
		return a.name - b.name;
	}
}
