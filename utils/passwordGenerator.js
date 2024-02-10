// utils/passwordGenerator.js
function generatePassword(passLength) {
  const lowCase = 'abcdefghijklmnopqrstuvxyz'
  const upperCase = 'ABCDEFGHIJKLMNOPQRSTUVXYZ'
  const numbers = '0123456789'
  const speChar = '£$&()*+[]@#^-_!?'

  const passCat = 4

  password = ''

  for(i=0;i<passLength;i++)
  {
      let chCat = Math.round(Math.random()*(passCat-1))
      
      switch(chCat)
      {
          case 0: 
              password = password + lowCase[(Math.round(Math.random()*(lowCase.length-1))+1)%(lowCase.length)]
              break

          case 1: 
              password = password + upperCase[(Math.round(Math.random()*(upperCase.length-1))+1)%(upperCase.length)]
              break
              
          case 2: 
              password = password + numbers[(Math.round(Math.random()*(numbers.length-1))+1)%(numbers.length)]
              break

          case 3: 
              password = password + speChar[(Math.round(Math.random()*(speChar.length-1))+1)%(speChar.length)]
              break
      }
  }

  return password;
}
  
module.exports = generatePassword;
  