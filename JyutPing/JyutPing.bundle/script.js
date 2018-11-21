const kSpeakCharacterHandler = 'SpeakCharacter';

function displayLookupResult(lookupResultArrayFromCocoa) {
    document.getElementById('append_content').innerHTML = '';
    for (var i in lookupResultArrayFromCocoa) {
        const item = lookupResultArrayFromCocoa[i];
        const element = document.createElement('div');
        const character = item.character;
        const pronunciation = item.pronunciation || '&nbsp;';
        if (!character || character == " ") {
            continue;
        }
        element.innerHTML = `<div class='jyutping'>${pronunciation}</div><div class='char_zh font_tc'>${character}</div>`;
        element.className = 'character';
        element.onclick = function() {
            window.webkit.messageHandlers[kSpeakCharacterHandler].postMessage(this.lastChild.innerText);
        };
        document.getElementById('append_content').appendChild(element);
    }
}