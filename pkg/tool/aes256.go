package tool

func AES256Encrypt(aesKey, target string) ([]byte, error) {
    tgt := []byte(target)
    key := sha256.Sum256([]byte(aesKey))

    block, err := aes.NewCipher(key[:])

    if err != nil { return nil, err }

    ret := make([]byte, aes.BlockSize + len(tgt))
    iv := ret[:aes.BlockSize]

    if _, err := io.ReadFull(rand.Reader, iv); err != nil { return nil, err }

    mode := cipher.NewCBCEncrypter(block, iv)
    mode.CryptBlocks(ret[aes.BlockSize:], tgt)

    return ret, nil
}

func AES256Decrypt(ciphertext []byte, keyString string) ([]byte, error) {
    key := sha256.Sum256([]byte(keyString))
    block, err := aes.NewCipher(key[:])
    if err != nil {
        return nil, err
    }

    if len(ciphertext) < aes.BlockSize {
        return nil, fmt.Errorf("Ciphertext is too short")
    }

    iv := ciphertext[:aes.BlockSize]
    ciphertext = ciphertext[aes.BlockSize:]

    mode := cipher.NewCBCDecrypter(block, iv)
    mode.CryptBlocks(ciphertext, ciphertext)

    return ciphertext, nil
}