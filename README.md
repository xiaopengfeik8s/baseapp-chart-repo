# BlossomV2

## Development workflow

After cloning a git repo, run:

`pnpm install`

to install all needed dependencies and then:

`npm run start`

to start a development server.

`npm run build`

to build dist files.

`npm run lint`

to check all files format and eslint

`npm run lint:fix`

to automatically fix all file formats in the src directory

`npm run i18n`

to do i18n, we need create `messages.ts` for every text that needs to be translated. then use the following command to build all files into the `src/locales/en-Us` by default.

Now you can start edit the source code — on changes, server will be reloaded and client code bundle will be rebuilt.

## How to release

release UAT env

1. `npm run build`
2. Copy the files in the dist directory.
3. open `backend-nodejs` project and if you don't have this project, you can clone it first [backend-nodejs repo url](https://codeup.aliyun.com/6234249787662be789e0f33d/Blossom/backend-nodejs)
4. Paste these files into `backend-nodejs/buildv2`
5. publish `backend-nodejs`

## Test environment

| env  | url                                                  |
| :--- | :--------------------------------------------------- |
| UAT  | https://blossom.chinacloudsites.cn/v2/referral/inbox |
| Prod | https://blossomcn.ap.jll.com/v2/referral/inbox       |

## New Feature develop

I recommand you to use `feature id` or `task id` as branch name and it is easy to track

`git checkout -b [feature id]`

## Files Structure

<!-- optional markdown-notes-tree directory description starts here -->

<!-- optional markdown-notes-tree directory description ends here -->

- [**_src_**](src/)
  - [**assets**](src/assets) `Store images`
  - [**components**](src/components) `These components used for all page`
  - [**layouts**](src/layouts) `Gloabl layout component`
  - [**locales**](src/locales) `I18n`
  - [**pages**](src/pages) `All routing components are stored here. When using convention routing, all (j|t)sx? files under convention pages are routes`
  - [**my**](src/pages/my) `Router my page`
  - [**referral**](src/pages/referral) `Router referral page`
    - [**components**](src/pages/referral/components) `Referral page used components`
    - [**config**](src/pages/referral/config) `Config referral page basic properties`
      - [**configType**](src/pages/referral/config/configType.ts) `It will export config object used type or interface`
      - [**inbox**](src/pages/referral/config/inbox.tsx) `Referral inbox page used config object, it defined basic properties for the inbox page`
      - [**outbox**](src/pages/referral/config/outbox.tsx) `It likes inbox config, but it used for referral outbox page`
    - [**messages.ts**](src/pages/referral/config/messages.ts) `This file will store all required message objects`
    - [**create**](src/pages/referral/create) `Router referral create page`
    - [**tome**](src/pages/referral/tome) `Router referral tome (detail) page`
      - [**components**](src/pages/referral/tome/components) `These components used for tome page`
  - [**searchclient**](src/pages/searchclient) `Router searchclient page`
  - [**whoswho**](src/pages/whoswho) `Router whoswho page`
  - [**utils**](src/utils) `These utils functions used for all page`
  - [**global.less**](src/global.less) `Define gloabl used styles`
- [**.umirc.ts**](.umirc.ts) `Configuration files that contain configurations for Umi's built-in features and plugins.`

## Design draft

Blossom [figma](https://www.figma.com/file/nTOLdkxqK2edEU5jyL26ya/Blossom?node-id=260%3A27004) : https://www.figma.com/file/nTOLdkxqK2edEU5jyL26ya/Blossom?node-id=260%3A27004

## Project info

Project [collaboration url](https://devops.aliyun.com/projex/project/3af0ccb44762c30c5956d19c6a) : https://devops.aliyun.com/projex/project/3af0ccb44762c30c5956d19c6a

## Reference

1. We have adopted [Umijs](https://umijs.org/) as the development framework
2. use [Antd]() as React UI component library based on Ant Design design system
3. Typescript [handbook](https://www.typescriptlang.org/docs/handbook/intro.html) https://www.typescriptlang.org/docs/handbook/intro.html
