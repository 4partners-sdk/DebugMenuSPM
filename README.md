
## Debug Menu SDK

Минималистичное debug-меню для внутреннего использования в iOS-проектах.

---

## Cтарт

1. Добавть `DebugMenu/` в свой Xcode-проект через SPM
   
Cсылкa: `https://github.com/4partners-sdk/DebugMenuSPM.git`

Dependency Rule: `Up To Next Major`

2. В `AppDelegate` или `SceneDelegate` добавь запуск:

```swift
DebugMenuService.shared.start()
```

Можно вызывать где угодно: в `application(_:didFinishLaunchingWithOptions:)`, координаторе и т.д.

---
## Активация меню

**Одновременный свайп тремя пальцами вверх** в любом месте приложения (работает глобально).

---

## Реализованные пункты меню

| Название           | Тип           | Описание                                                       |
|--------------------|---------------|----------------------------------------------------------------|
| Crash App          | Button        | Вызывает `fatalError()`                                        |
| Reset Onboarding   | Button        | Сбросить флаг onboarding                                       |
| Reset Onboarding   | Button        | Сбросить флаги onboarding/tutorial для фичей                                       |
| Toggle Premium     | Toggle        | Вкл/выкл `isUserPremium` (внешняя реализация)                  |
| Simulate Purchase     | Toggle        | Вкл/выкл симуляцию покупки, для проверки алерта ревью       |
| Negative Flow      | Toggle        | Использовать для проверки разного флоу покупки                 |
| Simulate Missing Product | Toggle  | Использовать для временно не подгружался paywall или продукт не отображался |
| Simulate Splash Error | Toggle     | Используется чтобы на сплеше всегда был error                  |
| Set Special Offer Timer to 10s | Toggle     | Используется для установки таймера на Special Offer 10 секунд|
| Set Security Center Timer to 3m | Toggle     | Используется для установки таймера Security Center на 3 минуты, вместо 24 часов|
| Simulate Old iOS Version | Toggle     | Используется для сравнения iOS версии                       |
| Set Email for Testing | Button     | Вызывает алерт, в котором мы можем сохранить email для последующего дебага email фичей |
| Open Generator     | Button        | Открывает генератор контактов и событий                        |

---

## Как добавить своё действие

В `DebugMenuActivator.swift`:

1. Добавь `case` в `enum DebugMenuItem`
2. Укажи `title` и `type`
3. Добавь метод в `DebugMenuActionHandler`
4. Реализуй его в `DebugMenuHandler`
5. Обработай `didSelectRowAt`

Пример:

```swift
enum DebugMenuItem: CaseIterable {
    case customFeature
    var title: String { "My Custom Feature" }
    var type: DebugMenuItemType { .button }
}

protocol DebugMenuActionHandler: AnyObject {
    func didTapCustomFeature()
}

final class DebugMenuHandler: DebugMenuActionHandler {
    func didTapCustomFeature() {
        print("Feature activated")
    }
}
```
---

Вызов меню — через одновременный свайп тремя пальцами вверх или шейк девайса 


