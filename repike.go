// Package repike implements Rob Pike's simple C regex matcher in Go. See
// https://benhoyt.com/writings/rob-pike-regex/
package repike

// Match reports whether regexp matches anywhere in text.
func Match(regexp, text string) bool {
	if len(regexp) > 0 && regexp[0] == '^' {
		return matchHere(regexp[1:], text)
	}
	for {
		if matchHere(regexp, text) {
			return true
		}
		if text == "" {
			break
		}
		text = text[1:]
	}
	return false
}

// matchHere reports whether regexp matches at beginning of text.
func matchHere(regexp, text string) bool {
	if regexp == "" {
		return true
	}
	if len(regexp) > 1 && regexp[1] == '*' {
		return matchStar(regexp[0], regexp[2:], text)
	}
	if regexp == "$" {
		return text == ""
	}
	if text != "" && (regexp[0] == '.' || regexp[0] == text[0]) {
		return matchHere(regexp[1:], text[1:])
	}
	return false
}

// matchStar reports whether c*regexp matches at beginning of text.
func matchStar(c byte, regexp, text string) bool {
	for {
		if matchHere(regexp, text) {
			return true
		}
		if !(text != "" && (text[0] == c || c == '.')) {
			break
		}
		text = text[1:]
	}
	return false
}
